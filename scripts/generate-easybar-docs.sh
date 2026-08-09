#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 PYTHON EASYBAR_ROOT CONTENT_OUTPUT" >&2
  exit 2
fi

python=$1
easybar_root=$2
content_output=$3
lua_output="$content_output/lua/reference"
config_output="$content_output/configuration/reference.md"

"$python" "$easybar_root/scripts/generate/lua_docs.py" --output "$lua_output"
if [[ ! -f "$lua_output/index.md" ]]; then
  legacy_lua_output="$easybar_root/docs/content/lua/reference"
  if [[ ! -d "$legacy_lua_output" ]]; then
    echo "EasyBar did not generate the Lua reference" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$lua_output")"
  cp -R "$legacy_lua_output" "$lua_output"
fi

(
  cd "$easybar_root"
  swift run EasyBarGenerateConfig config-docs "$config_output"
)
if [[ ! -f "$config_output" ]]; then
  legacy_config_output="$easybar_root/docs/content/configuration/reference.md"
  if [[ ! -f "$legacy_config_output" ]]; then
    echo "EasyBar did not generate the configuration reference" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$config_output")"
  cp "$legacy_config_output" "$config_output"
fi
