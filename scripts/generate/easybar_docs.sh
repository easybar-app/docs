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
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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

config_schema="$easybar_root/config.schema.json"
if [[ -f "$config_schema" ]]; then
  "$python" "$script_dir/config_docs.py" \
    --schema "$config_schema" \
    --output "$config_output"
else
  legacy_config_output="$easybar_root/docs/content/configuration/reference.md"
  if [[ ! -f "$legacy_config_output" ]]; then
    echo "EasyBar does not provide config.schema.json or a legacy configuration reference" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$config_output")"
  cp "$legacy_config_output" "$config_output"
fi
