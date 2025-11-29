# reprorusted-c-cli

Bootstrap corpus for [decy](https://github.com/paiml/decy) CITL oracle training.

## Overview

This repository contains C source files from GNU coreutils for training decy's Compiler-in-the-Loop (CITL) oracle. The oracle learns fix patterns for rustc errors, enabling cost-free steady-state C→Rust transpilation.

## Quick Start

```bash
# Extract coreutils sources
make extract-p0          # Tier P0 (trivial/simple)
make extract-all         # All tiers

# Run CITL training cycle
make citl-improve

# Check oracle statistics
make citl-stats
```

## Corpus Structure

```
examples/
├── coreutils_yes/       # P0: trivial (50 LOC)
├── coreutils_cat/       # P0: simple (150 LOC)
├── coreutils_cp/        # P1: medium (800 LOC)
├── coreutils_sort/      # P2: complex (1500 LOC)
└── ...
```

Each example contains:
- `original.c` - Source from GNU coreutils 9.4
- `metadata.yaml` - Function annotations, expected errors
- `transpiled.rs` - Generated Rust (after training)

## Error Coverage

| Code | Description | Coverage |
|------|-------------|----------|
| E0506 | Cannot assign to borrowed | 4 examples |
| E0499 | Multiple mutable borrows | 5 examples |
| E0382 | Use after move | 7 examples |
| E0308 | Type mismatch | 8 examples |
| E0133 | Unsafe required | 5 examples |
| E0597 | Does not live long enough | 3 examples |
| E0515 | Cannot return reference | 1 example |

## Cross-Project Seeding

Import patterns from depyler for faster bootstrap:

```bash
make citl-seed
```

## Specification

See [docs/specifications/examples-spec.md](docs/specifications/examples-spec.md) for:
- Selection methodology with 10 peer-reviewed citations
- Metadata schema
- Training workflow
- Validation criteria

## License

- Corpus tooling: MIT
- Coreutils sources: GPL-3.0 (GNU coreutils)

## Related

- [decy](https://github.com/paiml/decy) - C→Rust transpiler
- [depyler](https://github.com/paiml/depyler) - Python→Rust transpiler
- [entrenar](https://github.com/paiml/entrenar) - CITL training library
