SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

EASYBAR_KIT_REPOSITORY ?= https://github.com/easybar-app/easybar-kit.git
WIDGETS_REPOSITORY ?= https://github.com/easybar-app/widgets.git
EASYBAR_KIT_REF ?= main
WIDGETS_REF ?= main

SOURCES_DIR := .sources
EASYBAR_KIT_ROOT ?= $(SOURCES_DIR)/easybar-kit
WIDGETS_ROOT ?= $(SOURCES_DIR)/widgets
SITE_DIR := .site

VENV := .venv
PYTHON := $(VENV)/bin/python
DEPENDENCIES_STAMP := $(VENV)/.requirements-installed
PRETTIER ?= npx --yes prettier@3.9.6
IMAGE_CONVERT ?= magick
SVG_CONVERT ?= rsvg-convert
FAVICON_SOURCE ?=
CLICLICK ?= cliclick
SCREENSHOT_CONTEXT_MENU_POINT ?= 1344,16
ICON_SIZES := 16x16 32x32 48x48 64x64
PRETTIER_MD_SOURCES := README.md "content/**/*.md"
PRETTIER_YAML_SOURCES := ".github/**/*.{yml,yaml}" mkdocs.yml
PRETTIER_JSON_SOURCES := ".github/**/*.json"
GENERATED_MD_SOURCES := \
	content/configuration/reference.md \
	"content/lua/reference/**/*.md" \
	content/widget-store/catalog.md \
	"content/widget-store/packages/**/*.md"

.DEFAULT_GOAL := help

.PHONY: help build test check fetch generate serve \
        fmt fmt-md fmt-yaml fmt-json \
        lint lint-md lint-yaml lint-json \
        screenshot-context-menu screenshots check-screenshots favicon clean

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z\_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Build and test

build: $(DEPENDENCIES_STAMP) generate ## Build the production site into .site/.
	@$(PYTHON) -m mkdocs build --strict -f mkdocs.yml

test: build ## Build the complete documentation site.

check: test lint ## Run the complete repository verification suite.

##@ Documentation

fetch: ## Fetch the EasyBarKit and widgets revisions used by the site.
ifeq ($(SKIP_FETCH),1)
	@test -d "$(EASYBAR_KIT_ROOT)" || { echo "EasyBarKit source not found: $(EASYBAR_KIT_ROOT)" >&2; exit 1; }
	@test -d "$(WIDGETS_ROOT)" || { echo "Widgets source not found: $(WIDGETS_ROOT)" >&2; exit 1; }
else
	@scripts/sources/fetch.sh "$(EASYBAR_KIT_REPOSITORY)" "$(EASYBAR_KIT_REF)" "$(EASYBAR_KIT_ROOT)"
	@scripts/sources/fetch.sh "$(WIDGETS_REPOSITORY)" "$(WIDGETS_REF)" "$(WIDGETS_ROOT)"
endif

generate: fetch ## Generate reference and Widget Store pages directly in content/.
	@scripts/generate/kit_docs.sh "$(PYTHON)" "$(EASYBAR_KIT_ROOT)" \
		"$(abspath content)"
	@$(PYTHON) scripts/generate/widget_docs.py \
		--widgets-root "$(WIDGETS_ROOT)" \
		--output "$(abspath content/widget-store)"
	@$(PRETTIER) --write $(GENERATED_MD_SOURCES)

serve: $(DEPENDENCIES_STAMP) generate ## Serve content/ with live reload.
	@$(PYTHON) -m mkdocs serve -f mkdocs.yml

##@ Formatting

fmt: fmt-md fmt-yaml fmt-json ## Format all supported documentation and configuration files.

fmt-md: ## Format Markdown files with Prettier.
	@$(PRETTIER) --write $(PRETTIER_MD_SOURCES)

fmt-yaml: ## Format YAML files with Prettier.
	@$(PRETTIER) --write $(PRETTIER_YAML_SOURCES)

fmt-json: ## Format JSON configuration files with Prettier.
	@$(PRETTIER) --write $(PRETTIER_JSON_SOURCES)

lint: lint-md lint-yaml lint-json ## Check formatting without changing files.

lint-md: ## Check Markdown formatting with Prettier.
	@$(PRETTIER) --check $(PRETTIER_MD_SOURCES)

lint-yaml: ## Check YAML formatting with Prettier.
	@$(PRETTIER) --check $(PRETTIER_YAML_SOURCES)

lint-json: ## Check JSON formatting with Prettier.
	@$(PRETTIER) --check $(PRETTIER_JSON_SOURCES)

##@ Assets

screenshot-context-menu: ## Open EasyBar's native widgets context submenu for capture.
	@if ! command -v "$(CLICLICK)" >/dev/null 2>&1; then \
		echo 'Missing cliclick. Install it with: brew install cliclick' >&2; \
		exit 1; \
	fi
	@$(CLICLICK) "rc:$(SCREENSHOT_CONTEXT_MENU_POINT)"

screenshots: ## Regenerate consistently cropped documentation screenshots.
	@scripts/assets/screenshots.sh "$(IMAGE_CONVERT)" screenshots/screenshots.manifest \
		screenshots/raw content/assets

check-screenshots: ## Verify generated screenshots match their raw captures.
	@scripts/assets/screenshots.sh "$(IMAGE_CONVERT)" screenshots/screenshots.manifest \
		screenshots/raw content/assets --check

favicon: ## Generate site icons from an explicitly supplied frontend logo SVG.
	@test -n "$(FAVICON_SOURCE)" || { \
		echo 'Set FAVICON_SOURCE=/path/to/frontend-logo.svg.' >&2; \
		exit 1; \
	}
	@scripts/assets/favicons.sh "$(SVG_CONVERT)" \
		"$(FAVICON_SOURCE)" content/assets/icons $(ICON_SIZES)

##@ Maintenance

clean: ## Remove fetched sources and generated documentation artifacts.
	@python3 scripts/maintenance/clean.py

$(PYTHON):
	@python3 -m venv "$(VENV)"

$(DEPENDENCIES_STAMP): requirements.txt | $(PYTHON)
	@$(PYTHON) -m pip install --upgrade pip
	@$(PYTHON) -m pip install -r requirements.txt
	@touch "$(DEPENDENCIES_STAMP)"
