SHELL := /bin/bash
.DEFAULT_GOAL := help

UNIT_GLOB ?= tests/units/*_test.yaml
SMOKE_ARGS ?=
E2E_ARGS ?=

.PHONY: help
help: ## Show available local targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: deps
deps: ## Ensure chart dependencies from Chart.yaml are available locally
	bash scripts/helm-deps.sh .

.PHONY: lint
lint: deps ## Run helm lint with the example values file
	helm lint . -f values.yaml.example

.PHONY: hooks-install
hooks-install: ## Install local pre-commit hooks
	pre-commit install
	pre-commit install-hooks

.PHONY: docs
docs: ## Regenerate README.md from docs/README.md.gotmpl via helm-docs
	bash scripts/helm-docs.sh

.PHONY: test
test: test-unit test-smoke-fast ## Run local fast checks

.PHONY: test-unit
test-unit: deps ## Run helm-unittest suites from tests/units
	helm unittest --with-subchart=false -f '$(UNIT_GLOB)' .

.PHONY: test-compat
test-compat: deps ## Run backward compatibility checks against previous tags
	sh tests/units/backward_compatibility_test.sh

.PHONY: test-smoke
test-smoke: deps ## Run all smoke scenarios; append SMOKE_ARGS='--scenario example-render'
	python3 tests/smokes/run/smoke.py $(SMOKE_ARGS)

.PHONY: test-smoke-fast
test-smoke-fast: deps ## Run smoke scenarios except kubeconform-dependent validation
	python3 tests/smokes/run/smoke.py \
		--scenario default-empty \
		--scenario schema-invalid-list-contract \
		--scenario rendering-contract \
		--scenario example-render \
		$(SMOKE_ARGS)

.PHONY: test-e2e
test-e2e: deps ## Run local kind-based end-to-end tests
	bash tests/e2e/test-e2e.sh $(E2E_ARGS)

.PHONY: test-e2e-debug
test-e2e-debug: deps ## Run e2e tests with Helm debug output
	bash tests/e2e/test-e2e.sh --debug $(E2E_ARGS)

.PHONY: test-e2e-help
test-e2e-help: ## Show e2e runner help and supported environment overrides
	bash tests/e2e/test-e2e.sh --help
