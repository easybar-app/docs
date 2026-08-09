"""Remove generated documentation artifacts within the repository."""

from __future__ import annotations

from pathlib import Path
import shutil
import sys


def main() -> int:
    root = Path.cwd().resolve()
    allowed = {root / ".sources", root / ".build", root / ".site"}

    for argument in sys.argv[1:]:
        target = Path(argument).resolve()
        if target not in allowed:
            raise SystemExit(f"Refusing to remove unexpected path: {target}")
        if target.exists():
            shutil.rmtree(target)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
