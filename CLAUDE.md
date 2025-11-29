# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bootstrap corpus for [decy](https://github.com/paiml/decy) CITL (Compiler-in-the-Loop) oracle training. Contains C source files from GNU coreutils 9.4 used to train patterns for C→Rust transpilation error fixes.

## Commands

```bash
# Setup directory structure
make setup

# Download and extract coreutils sources
make download-coreutils      # Download coreutils 9.4
make extract-p0              # Extract P0 tier (trivial/simple utilities)
make extract-p1              # Extract P1 tier (core utilities)
make extract-p2              # Extract P2 tier (advanced utilities)
make extract-all             # Extract all tiers

# CITL training workflow
make citl-train              # Transpile corpus and capture patterns
make citl-export             # Export patterns to decision_patterns.apr
make citl-validate           # Validate pattern quality
make citl-improve            # Full improvement cycle (train + export + validate)
make citl-stats              # Show oracle statistics
make citl-seed               # Import patterns from depyler

# Cleanup
make clean                   # Remove generated files
make distclean               # Remove generated files and cache
```

## Architecture

### Corpus Structure

```
examples/
├── coreutils_{utility}/
│   ├── original.c           # Source from GNU coreutils 9.4
│   ├── metadata.yaml        # Function annotations, expected errors
│   └── transpiled.rs        # Generated Rust (after training)
training_corpus/
└── citl.log                  # Training session logs
decision_patterns.apr         # Exported oracle patterns
corpus_metadata.yaml          # Corpus-level statistics
```

### Priority Tiers

- **P0** (trivial/simple): yes, true, false, echo, cat, wc, head, tail
- **P1** (medium complexity): cp, mv, rm, ls, mkdir, ln
- **P2** (complex): sort, uniq, chmod, chown, cut

### Rustc Error Coverage

Primary error codes targeted for oracle training:
- E0506: Cannot assign to borrowed
- E0499: Multiple mutable borrows
- E0382: Use after move
- E0308: Type mismatch
- E0133: Unsafe required
- E0597: Does not live long enough
- E0515: Cannot return reference

### CITL Workflow

1. Transpile corpus with `decy transpile --oracle --capture-patterns`
2. Aggregate error patterns with `decy citl aggregate`
3. Export patterns to `.apr` format
4. Validate pattern quality (minimum 100 patterns, all error codes covered)
5. Iterate to improve oracle accuracy

### Related Projects

- [decy](https://github.com/paiml/decy) - C→Rust transpiler (consumer of this corpus)
- [depyler](https://github.com/paiml/depyler) - Python→Rust transpiler (pattern source for cross-project seeding)
- [entrenar](https://github.com/paiml/entrenar) - CITL training library
