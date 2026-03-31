from __future__ import annotations

from pathlib import Path

import yaml

from tests.smokes.steps.system import TestFailure


def load_documents(manifest_path: Path) -> list[dict]:
    with manifest_path.open("r", encoding="utf-8") as handle:
        documents = [doc for doc in yaml.safe_load_all(handle) if doc]
    return documents


def assert_doc_count(documents: list[dict], expected: int) -> None:
    actual = len(documents)
    if actual != expected:
        raise TestFailure(f"expected {expected} rendered documents, got {actual}")


def assert_kinds(documents: list[dict], expected_kinds: set[str]) -> None:
    actual_kinds = {document.get("kind") for document in documents}
    missing = sorted(expected_kinds - actual_kinds)
    if missing:
        raise TestFailure(f"missing rendered resource kinds: {', '.join(missing)}")


def select_document(documents: list[dict], *, kind: str, name: str) -> dict:
    for document in documents:
        if document.get("kind") == kind and document.get("metadata", {}).get("name") == name:
            return document
    raise TestFailure(f"failed to find rendered document {kind}/{name}")


def _resolve_path(document: dict, path: str):
    current = document
    for token in _parse_path(path):
        if isinstance(token, int):
            if not isinstance(current, list) or token >= len(current):
                raise KeyError(path)
            current = current[token]
        else:
            key = token
            if not isinstance(current, dict) or key not in current:
                raise KeyError(path)
            current = current[key]
    return current


def _parse_path(path: str) -> list[object]:
    tokens: list[object] = []
    index = 0
    while index < len(path):
        if path[index] == ".":
            index += 1
            continue
        if path[index] == "[":
            end = path.find("]", index)
            if end == -1:
                raise TestFailure(f"invalid path syntax: {path}")
            raw_token = path[index + 1 : end].strip().strip("\"'")
            if raw_token.isdigit():
                tokens.append(int(raw_token))
            else:
                tokens.append(raw_token)
            index = end + 1
            continue

        end = index
        while end < len(path) and path[end] not in ".[":
            end += 1
        tokens.append(path[index:end])
        index = end
    return tokens


def assert_path(document: dict, path: str, expected) -> None:
    try:
        actual = _resolve_path(document, path)
    except KeyError as exc:
        raise TestFailure(f"missing path {path}") from exc
    if actual != expected:
        raise TestFailure(f"path {path} expected {expected!r}, got {actual!r}")


def assert_path_missing(document: dict, path: str) -> None:
    try:
        _resolve_path(document, path)
    except KeyError:
        return
    raise TestFailure(f"path {path} was expected to be absent")
