#!/usr/bin/env bash
# Generate Lua and configuration reference pages from EasyBarKit.
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 PYTHON EASYBAR_KIT_ROOT CONTENT_OUTPUT" >&2
  exit 2
fi

python=$1
easybar_kit_root=$2
content_output=$3
lua_output="$content_output/lua/reference"
config_output="$content_output/products/easybar/configuration/reference.md"
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

lua_generator="$easybar_kit_root/scripts/generate/lua_docs.py"
if [[ ! -f "$lua_generator" ]]; then
  echo "EasyBarKit Lua documentation generator not found: $lua_generator" >&2
  exit 1
fi

"$python" "$lua_generator" --output "$lua_output"
if [[ ! -f "$lua_output/index.md" ]]; then
  echo "EasyBarKit did not generate the Lua reference at $lua_output" >&2
  exit 1
fi

config_schema="$easybar_kit_root/config.schema.json"
if [[ ! -f "$config_schema" ]]; then
  echo "EasyBarKit configuration schema not found: $config_schema" >&2
  exit 1
fi

"$python" "$script_dir/config_docs.py" \
  --schema "$config_schema" \
  --output "$config_output"
