"""Create the disposable MkDocs content tree from hand-written sources."""

from __future__ import annotations

from pathlib import Path
import shutil
import sys


def main() -> int:
    if len(sys.argv) != 3:
        raise SystemExit("Usage: prepare_content.py SOURCE DESTINATION")

    root = Path.cwd().resolve()
    source = Path(sys.argv[1]).resolve()
    destination = Path(sys.argv[2]).resolve()
    build_root = root / ".build"

    if source != root / "content":
        raise SystemExit(f"Unexpected content source: {source}")
    if destination.parent != build_root:
        raise SystemExit(f"Refusing to replace content outside {build_root}: {destination}")

    if destination.exists():
        shutil.rmtree(destination)
    shutil.copytree(source, destination)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
