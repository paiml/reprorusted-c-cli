# Corpus Overview

The reprorusted-c-cli corpus provides C source files for training decy's CITL oracle.

## Design Principles

1. **Error Diversity**: Cover all major rustc error categories
2. **Complexity Gradient**: Range from trivial (10 LOC) to complex (1500 LOC)
3. **Real-World Provenance**: Use production code rather than synthetic examples
4. **Reproducibility**: Pin exact source versions for deterministic training

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

## Statistics

| Metric | Value |
|--------|-------|
| Total Examples | 19 |
| Total Functions | 47 |
| Total LOC | 6,180 |
| Error Codes | 7 |

## Tier Breakdown

| Tier | Examples | Functions | LOC |
|------|----------|-----------|-----|
| P0 | 8 | 18 | 1,030 |
| P1 | 6 | 17 | 3,500 |
| P2 | 5 | 12 | 1,650 |
