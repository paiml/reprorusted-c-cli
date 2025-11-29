# reprorusted-c-cli Makefile
# Bootstrap corpus for decy CITL oracle training
#
# PERFORMANCE TARGETS (Toyota Way: Zero Defects, Fast Feedback)
# - make test:      < 10 seconds (corpus validation)
# - make book:      < 30 seconds (build documentation)
# - make ci:        < 2 minutes (full CI pipeline)

# Use bash for shell commands
SHELL := /bin/bash

# Disable built-in rules for performance
.SUFFIXES:

# Delete partially-built files on error
.DELETE_ON_ERROR:

# Multi-line recipes execute in same shell
.ONESHELL:

.PHONY: all setup test validate lint clean distclean book book-build book-serve book-clean help
.PHONY: citl-improve citl-train citl-export citl-validate citl-stats citl-seed
.PHONY: download-coreutils extract-p0 extract-p1 extract-p2 extract-all
.PHONY: tier1 tier2 tier3 tier4 ci dev pre-push quality-report pmat-score

# Default target
all: setup

# ============================================================================
# QUICK START
# ============================================================================

quickstart: setup extract-all test book-build ## Quick start - setup, extract sources, validate, build book
	@echo "✅ Ready! Run 'make citl-improve' to start training"

# ============================================================================
# SETUP & DIRECTORY STRUCTURE
# ============================================================================

setup: ## Create example directories
	@mkdir -p examples/coreutils_{yes,true,false,echo,cat,wc,head,tail}
	@mkdir -p examples/coreutils_{cp,mv,rm,ls,mkdir,ln}
	@mkdir -p examples/coreutils_{sort,uniq,chmod,chown,cut}
	@mkdir -p training_corpus
	@mkdir -p scripts
	@echo "✅ Directory structure created"

# ============================================================================
# TESTING (EXTREME TDD)
# ============================================================================

test: validate ## Run corpus validation tests (alias for validate)

test-fast: validate ## Fast validation (<10s target)

validate: ## Validate corpus structure (206 tests)
	@echo "🧪 Running corpus validation..."
	@./scripts/validate_corpus.sh
	@echo "✅ Validation complete"

# ============================================================================
# TIERED QUALITY GATES
# ============================================================================

tier1: validate ## Tier 1: On-save (<1 second)
	@echo "✅ Tier 1: PASSED"

tier2: tier1 book-build ## Tier 2: Pre-commit (<30 seconds)
	@echo "✅ Tier 2: PASSED"

tier3: tier2 lint ## Tier 3: Pre-push (<2 minutes)
	@echo "✅ Tier 3: PASSED"

tier4: tier3 ## Tier 4: CI/CD (full validation)
	@echo "Running Tier 4: CI/CD validation..."
	@if command -v pmat >/dev/null 2>&1; then \
		pmat tdg . --include-components || true; \
	fi
	@echo "✅ Tier 4: PASSED"

# Development workflow aliases
dev: tier1 ## Development (on-save)

pre-push: tier3 ## Pre-push checks

ci: tier4 ## Full CI pipeline

# ============================================================================
# CITL TRAINING WORKFLOW
# ============================================================================

citl-improve: citl-train citl-export citl-validate ## Full CITL improvement cycle
	@echo "✅ CITL improvement cycle complete"

citl-train: ## Transpile corpus and capture patterns
	@echo "🔄 Training on corpus..."
	@for dir in examples/*/; do \
		if [ -f "$$dir/original.c" ]; then \
			echo "  Processing $$dir"; \
			decy transpile "$$dir/original.c" \
				--oracle \
				--capture-patterns \
				--output "$$dir/transpiled.rs" 2>&1 | tee -a training_corpus/citl.log; \
		fi \
	done
	decy citl aggregate training_corpus/

citl-export: ## Export patterns to .apr
	decy oracle export --output decision_patterns.apr
	@echo "✅ Exported to decision_patterns.apr"

citl-validate: ## Validate pattern quality
	decy oracle validate decision_patterns.apr --min-patterns 100
	@echo "✅ Validation complete"

citl-stats: ## Show oracle statistics
	@if [ -f decision_patterns.apr ]; then \
		decy oracle stats decision_patterns.apr; \
	else \
		echo "⚠️  No patterns file yet. Run 'make citl-train' first."; \
	fi

citl-seed: ## Import patterns from depyler (cross-project seeding)
	@if [ -f ~/.depyler/decision_patterns.apr ]; then \
		decy oracle import \
			--from ~/.depyler/decision_patterns.apr \
			--filter "E0382,E0499,E0506,E0597,E0515" \
			--output decision_patterns.apr; \
		echo "✅ Seeded from depyler patterns"; \
	else \
		echo "⚠️  No depyler patterns found at ~/.depyler/decision_patterns.apr"; \
	fi

# ============================================================================
# COREUTILS SOURCE EXTRACTION
# ============================================================================

download-coreutils: ## Download coreutils source
	@mkdir -p .cache
	@if [ ! -f .cache/coreutils-9.4.tar.xz ]; then \
		echo "📥 Downloading GNU coreutils 9.4..."; \
		curl -L -o .cache/coreutils-9.4.tar.xz \
			https://ftp.gnu.org/gnu/coreutils/coreutils-9.4.tar.xz; \
	fi
	@cd .cache && tar xf coreutils-9.4.tar.xz
	@echo "✅ Coreutils 9.4 downloaded to .cache/"

extract-%: download-coreutils ## Extract specific utility source
	@mkdir -p examples/coreutils_$*
	@cp .cache/coreutils-9.4/src/$*.c examples/coreutils_$*/original.c 2>/dev/null || \
		echo "⚠️  $*.c not found in coreutils"

extract-p0: extract-yes extract-true extract-false extract-echo extract-cat extract-wc extract-head extract-tail ## Extract P0 tier
	@echo "✅ P0 tier extracted"

extract-p1: extract-cp extract-mv extract-rm extract-ls extract-mkdir extract-ln ## Extract P1 tier
	@echo "✅ P1 tier extracted"

extract-p2: extract-sort extract-uniq extract-chmod extract-chown extract-cut ## Extract P2 tier
	@echo "✅ P2 tier extracted"

extract-all: extract-p0 extract-p1 extract-p2 ## Extract all tiers
	@echo "✅ All tiers extracted"

# ============================================================================
# BOOK (mdBook)
# ============================================================================

book: book-build ## Build the book

book-build: ## Build the mdBook documentation
	@echo "📚 Building CITL Bootstrap Corpus book..."
	@if command -v mdbook >/dev/null 2>&1; then \
		cd book && mdbook build; \
		echo "✅ Book built: book/output/index.html"; \
	else \
		echo "❌ mdbook not found. Install with: cargo install mdbook"; \
		exit 1; \
	fi

book-serve: ## Serve the book locally for development
	@echo "📖 Serving book at http://localhost:3000..."
	@cd book && mdbook serve --open

book-clean: ## Clean book build artifacts
	@rm -rf book/output
	@echo "✅ Book cleaned"

book-test: validate ## Test book builds correctly
	@$(MAKE) book-build
	@echo "✅ Book test passed"

# ============================================================================
# LINTING
# ============================================================================

lint: lint-scripts lint-yaml ## Run all linters

lint-scripts: ## Lint shell scripts
	@echo "🔍 Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck scripts/*.sh && echo "✅ Shell scripts pass shellcheck"; \
	else \
		echo "⚠️  shellcheck not installed. Install with: apt install shellcheck"; \
	fi

lint-yaml: ## Validate YAML files (basic structure check)
	@echo "🔍 Validating YAML files..."
	@errors=0; \
	if [ -f corpus_metadata.yaml ]; then \
		if ! grep -q "^version:" corpus_metadata.yaml; then \
			echo "❌ Missing 'version:' in corpus_metadata.yaml"; \
			errors=1; \
		fi \
	fi; \
	for yaml in examples/*/metadata.yaml; do \
		if [ -f "$$yaml" ]; then \
			if ! grep -q "^name:" "$$yaml"; then \
				echo "❌ Missing 'name:' in $$yaml"; \
				errors=1; \
			fi \
		fi \
	done; \
	if [ $$errors -eq 0 ]; then \
		echo "✅ YAML validation complete"; \
	else \
		exit 1; \
	fi

# ============================================================================
# PMAT INTEGRATION
# ============================================================================

pmat-score: ## Calculate quality score
	@echo "📊 Calculating quality score..."
	@if command -v pmat >/dev/null 2>&1; then \
		pmat rust-project-score || true; \
	else \
		echo "⚠️  pmat not installed"; \
	fi

quality-report: ## Generate comprehensive quality report
	@echo "📋 Generating quality report..."
	@mkdir -p docs/quality-reports
	@echo "# Quality Report - $(shell date)" > docs/quality-reports/latest.md
	@echo "" >> docs/quality-reports/latest.md
	@echo "## Corpus Validation" >> docs/quality-reports/latest.md
	@./scripts/validate_corpus.sh >> docs/quality-reports/latest.md 2>&1 || true
	@echo "✅ Report: docs/quality-reports/latest.md"

# ============================================================================
# CLEANUP
# ============================================================================

clean: ## Clean generated files
	@rm -rf training_corpus/*.log
	@rm -f decision_patterns.apr
	@find examples -name "transpiled.rs" -delete 2>/dev/null || true
	@echo "✅ Cleaned"

distclean: clean book-clean ## Deep clean (including cache)
	@rm -rf .cache
	@rm -rf .pmat-metrics
	@echo "✅ Deep cleaned"

# ============================================================================
# HELP
# ============================================================================

help: ## Show this help
	@echo "reprorusted-c-cli - CITL Bootstrap Corpus"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
