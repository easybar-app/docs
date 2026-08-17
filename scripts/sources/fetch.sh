#!/usr/bin/env bash
# Fetch a pinned repository revision into the local source cache.
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 REPOSITORY REF DESTINATION" >&2
  exit 2
fi

repository=$1
reference=$2
destination=$3
root=$(pwd -P)
sources_root="$root/.sources"

mkdir -p "$sources_root"
destination_parent=$(cd "$(dirname "$destination")" && pwd -P)
if [[ "$destination_parent" != "$sources_root" ]]; then
  echo "Refusing to manage source outside $sources_root: $destination" >&2
  exit 1
fi

if [[ ! -d "$destination/.git" ]]; then
  if [[ -e "$destination" ]]; then
    echo "Source destination exists but is not a Git checkout: $destination" >&2
    exit 1
  fi
  git clone --filter=blob:none --no-checkout "$repository" "$destination"
elif [[ "$(git -C "$destination" remote get-url origin)" != "$repository" ]]; then
  echo "Unexpected origin for $destination" >&2
  exit 1
fi

git -C "$destination" fetch --depth=1 origin "$reference"
git -C "$destination" checkout --detach --force FETCH_HEAD
printf '%s: %s\n' "$(basename "$destination")" "$(git -C "$destination" rev-parse HEAD)"
