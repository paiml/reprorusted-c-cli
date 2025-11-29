# Introduction

**reprorusted-c-cli** is a bootstrap corpus for training [decy](https://github.com/paiml/decy)'s Compiler-in-the-Loop (CITL) oracle. The oracle learns fix patterns for rustc errors, enabling cost-free steady-state C→Rust transpilation.

## What is This Corpus?

This repository contains C source files from GNU coreutils 9.4, carefully selected to provide comprehensive coverage of Rust ownership errors that arise during C→Rust transpilation.

## Key Features

- **19 examples** across 3 priority tiers (P0, P1, P2)
- **7 rustc error codes** covered (E0506, E0499, E0382, E0308, E0133, E0597, E0515)
- **Real-world provenance** from production GNU coreutils code
- **Reproducible** with pinned source versions

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    CITL IMPROVEMENT LOOP                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Corpus ──► Transpile ──► Errors ──► LLM Fix ──► Patterns  │
│    │                                                  │     │
│    │                                                  │     │
│    └──────────────────── Oracle ◄─────────────────────┘     │
│                            │                                │
│                            ▼                                │
│                     decision_patterns.apr                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Each iteration:
1. Transpile corpus with current oracle
2. Capture new error patterns
3. Query LLM for unseen errors only
4. Index successful fixes
5. Export updated `.apr` patterns

## Quick Start

```bash
# Extract coreutils sources
make extract-all

# Run CITL training cycle
make citl-improve

# Check oracle statistics
make citl-stats

# Validate corpus structure
make test
```

## Related Projects

- [decy](https://github.com/paiml/decy) - C→Rust transpiler (consumer of this corpus)
- [depyler](https://github.com/paiml/depyler) - Python→Rust transpiler (pattern source)
- [entrenar](https://github.com/paiml/entrenar) - CITL training library
