from __future__ import annotations

from pathlib import Path

from tests.smokes.steps import system


def helm_env(workdir: Path) -> dict[str, str]:
    cache_home = workdir / ".helm" / "cache"
    config_home = workdir / ".helm" / "config"
    data_home = workdir / ".helm" / "data"
    system.ensure_dir(cache_home)
    system.ensure_dir(config_home)
    system.ensure_dir(data_home)
    return {
        "HELM_NO_PLUGINS": "1",
        "HELM_CACHE_HOME": str(cache_home),
        "HELM_CONFIG_HOME": str(config_home),
        "HELM_DATA_HOME": str(data_home),
    }


def dependency_update(chart_dir: Path, *, workdir: Path) -> system.CommandResult:
    command = ["helm", "dependency", "update", str(chart_dir)]
    return system.run(command, cwd=chart_dir, env=helm_env(workdir), check=True)


def dependencies_ready(chart_dir: Path, *, workdir: Path) -> bool:
    command = ["helm", "dependency", "list", str(chart_dir)]
    result = system.run(command, cwd=chart_dir, env=helm_env(workdir), check=True)
    lines = [line for line in result.stdout.splitlines()[1:] if line.strip()]
    return all(line.split()[-1] == "ok" for line in lines)


def ensure_dependencies(chart_dir: Path, *, workdir: Path) -> None:
    if dependencies_ready(chart_dir, workdir=workdir):
        return
    dependency_update(chart_dir, workdir=workdir)


def lint(
    chart_dir: Path,
    *,
    workdir: Path,
    values_file: Path | None = None,
    check: bool = True,
) -> system.CommandResult:
    command = ["helm", "lint", str(chart_dir)]
    if values_file is not None:
        command.extend(["-f", str(values_file)])
    ensure_dependencies(chart_dir, workdir=workdir)
    return system.run(command, cwd=chart_dir, env=helm_env(workdir), check=check)


def template(
    chart_dir: Path,
    *,
    release_name: str,
    namespace: str,
    output_path: Path,
    workdir: Path,
    values_file: Path | None = None,
) -> Path:
    command = [
        "helm",
        "template",
        release_name,
        str(chart_dir),
        "--namespace",
        namespace,
    ]
    if values_file is not None:
        command.extend(["-f", str(values_file)])

    ensure_dependencies(chart_dir, workdir=workdir)
    result = system.run(command, cwd=chart_dir, env=helm_env(workdir), check=True)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(result.stdout, encoding="utf-8")
    return output_path
