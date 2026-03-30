from __future__ import annotations

from pathlib import Path
import shutil
import tempfile


FILES_TO_COPY = [
    "Chart.yaml",
    "Chart.lock",
    "values.yaml",
    "values.yaml.example",
    "values.schema.json",
]

DIRS_TO_COPY = [
    "charts",
    "templates",
]


def stage_chart(source_dir: Path, requested_workdir: str | None) -> tuple[Path, Path]:
    source_dir = source_dir.resolve()
    if requested_workdir:
        workdir = Path(requested_workdir).resolve()
        if workdir.exists():
            shutil.rmtree(workdir)
        workdir.mkdir(parents=True, exist_ok=True)
    else:
        workdir = Path(tempfile.mkdtemp(prefix="nxs-universal-chart-smokes-"))

    chart_dir = workdir / "chart"
    chart_dir.mkdir(parents=True, exist_ok=True)

    for relative_path in FILES_TO_COPY:
        source = source_dir / relative_path
        if source.exists():
            shutil.copy2(source, chart_dir / relative_path)

    for relative_path in DIRS_TO_COPY:
        source = source_dir / relative_path
        destination = chart_dir / relative_path
        if source.exists():
            shutil.copytree(source, destination, dirs_exist_ok=True)

    return workdir, chart_dir


def cleanup(workdir: Path) -> None:
    shutil.rmtree(workdir, ignore_errors=True)
