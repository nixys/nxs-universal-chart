from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import os
import shlex
import subprocess


class TestFailure(RuntimeError):
    """Raised when a smoke-test check fails."""


@dataclass
class CommandResult:
    command: list[str]
    returncode: int
    stdout: str
    stderr: str


def log(message: str) -> None:
    print(message, flush=True)


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def format_command(command: list[str]) -> str:
    return shlex.join(str(part) for part in command)


def run(
    command: list[str],
    *,
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
    check: bool = True,
) -> CommandResult:
    log(f"$ {format_command(command)}")
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)

    completed = subprocess.run(
        [str(part) for part in command],
        cwd=str(cwd) if cwd else None,
        env=merged_env,
        capture_output=True,
        text=True,
        check=False,
    )
    result = CommandResult(
        command=[str(part) for part in command],
        returncode=completed.returncode,
        stdout=completed.stdout,
        stderr=completed.stderr,
    )
    if check and completed.returncode != 0:
        details = []
        if completed.stdout.strip():
            details.append(f"stdout:\n{completed.stdout.rstrip()}")
        if completed.stderr.strip():
            details.append(f"stderr:\n{completed.stderr.rstrip()}")
        detail_text = "\n".join(details)
        raise TestFailure(
            f"command failed with exit code {completed.returncode}: {format_command(command)}"
            + (f"\n{detail_text}" if detail_text else "")
        )
    return result
