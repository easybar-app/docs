"""Remove generated documentation artifacts within the repository."""

from __future__ import annotations

from pathlib import Path
import shutil


def remove(path: Path) -> None:
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    elif path.exists() or path.is_symlink():
        path.unlink()


def main() -> int:
    root = Path.cwd().resolve()
    targets = (
        root / ".sources",
        root / ".build",
        root / ".site",
        root / "content/products/easybar/configuration/reference.md",
        root / "content/lua/reference",
        root / "content/widget-store/catalog.md",
        root / "content/widget-store/packages",
    )

    for target in targets:
        remove(target)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
