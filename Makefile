SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

EASYBAR_REPOSITORY ?= https://github.com/easybar-app/easybar.git
WIDGETS_REPOSITORY ?= https://github.com/easybar-app/widgets.git
EASYBAR_REF ?= main
WIDGETS_REF ?= main

SOURCES_DIR := .sources
EASYBAR_ROOT ?= $(SOURCES_DIR)/easybar
WIDGETS_ROOT ?= $(SOURCES_DIR)/widgets
BUILD_DIR := .build
BUILD_CONTENT := $(BUILD_DIR)/content
SITE_DIR := .site

VENV := .venv
PYTHON := $(VENV)/bin/python
DEPENDENCIES_STAMP := $(VENV)/.requirements-installed
PRETTIER ?= npx --yes prettier@3.9.6
IMAGE_CONVERT ?= magick
SVG_CONVERT ?= rsvg-convert
CLICLICK ?= cliclick
SCREENSHOT_CONTEXT_MENU_POINT ?= 1344,16
ICON_SIZES := 16x16 32x32 48x48 64x64
PRETTIER_SOURCES := README.md "content/**/*.md" ".github/**/*.yml" mkdocs.yml

.DEFAULT_GOAL := help

.PHONY: help fetch generate build serve fmt check screenshot-context-menu screenshots check-screenshots favicon clean

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

fetch: ## Fetch the EasyBar and widgets revisions used by the site.
ifeq ($(SKIP_FETCH),1)
	@test -d "$(EASYBAR_ROOT)" || { echo "EasyBar source not found: $(EASYBAR_ROOT)" >&2; exit 1; }
	@test -d "$(WIDGETS_ROOT)" || { echo "Widgets source not found: $(WIDGETS_ROOT)" >&2; exit 1; }
else
	@scripts/fetch-source.sh "$(EASYBAR_REPOSITORY)" "$(EASYBAR_REF)" "$(EASYBAR_ROOT)"
	@scripts/fetch-source.sh "$(WIDGETS_REPOSITORY)" "$(WIDGETS_REF)" "$(WIDGETS_ROOT)"
endif

generate: fetch ## Assemble hand-written and generated documentation.
	@$(PYTHON) scripts/prepare_content.py content "$(BUILD_CONTENT)"
	@scripts/generate-easybar-docs.sh "$(PYTHON)" "$(EASYBAR_ROOT)" \
		"$(abspath $(BUILD_CONTENT))"
	@$(PYTHON) scripts/generate/widget_docs.py \
		--widgets-root "$(WIDGETS_ROOT)" \
		--output "$(BUILD_CONTENT)/packages"
	@$(PRETTIER) --write "$(BUILD_CONTENT)/**/*.md"

build: $(DEPENDENCIES_STAMP) generate ## Build the production site into .site/.
	@$(PYTHON) -m mkdocs build --strict -f mkdocs.yml

serve: $(DEPENDENCIES_STAMP) generate ## Serve the assembled site with live reload.
	@$(PYTHON) -m mkdocs serve -f mkdocs.yml

fmt: ## Format hand-written Markdown and YAML.
	@$(PRETTIER) --write $(PRETTIER_SOURCES)

check: build ## Verify formatting and build the complete site.
	@$(PRETTIER) --check $(PRETTIER_SOURCES)

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

favicon: fetch ## Generate site icons from EasyBar's application logo.
	@scripts/assets/favicons.sh "$(SVG_CONVERT)" \
		"$(EASYBAR_ROOT)/packaging/easybar-icon.svg" content/assets/icons $(ICON_SIZES)

clean: ## Remove fetched sources and generated build artifacts.
	@python3 scripts/clean.py "$(SOURCES_DIR)" "$(BUILD_DIR)" "$(SITE_DIR)"

$(PYTHON):
	@python3 -m venv "$(VENV)"

$(DEPENDENCIES_STAMP): requirements.txt | $(PYTHON)
	@$(PYTHON) -m pip install --upgrade pip
	@$(PYTHON) -m pip install -r requirements.txt
	@touch "$(DEPENDENCIES_STAMP)"
