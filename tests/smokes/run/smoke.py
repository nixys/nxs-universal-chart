from __future__ import annotations

from pathlib import Path
import sys

REPO_ROOT = Path(__file__).resolve().parents[3]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from tests.smokes.helpers.argparser import build_parser
from tests.smokes.scenarios.smoke import run_smoke_suite


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return run_smoke_suite(args)


if __name__ == "__main__":
    raise SystemExit(main())
