# Priority Tiers

## Tier P0: Baseline (Trivial/Simple)

| Example | LOC | Primary Errors | Rationale |
|---------|-----|----------------|-----------|
| `yes` | 50 | E0308 | Simplest possible loop + I/O |
| `true` | 10 | — | Baseline: should compile clean |
| `false` | 10 | — | Baseline: should compile clean |
| `echo` | 80 | E0308 | String handling, argc/argv |
| `cat` | 150 | E0506, E0382 | File I/O, buffer management |
| `wc` | 200 | E0308, E0382 | Counting, state machines |
| `head` | 180 | E0597, E0515 | Line buffering, early exit |
| `tail` | 350 | E0499, E0506 | Ring buffer, complex state |

## Tier P1: Core Utilities (Medium)

| Example | LOC | Primary Errors | Rationale |
|---------|-----|----------------|-----------|
| `cp` | 800 | E0499, E0133 | Deep copy, permission bits |
| `mv` | 600 | E0382, E0506 | Move semantics |
| `rm` | 400 | E0133, E0382 | Recursive delete, unsafe |
| `ls` | 1200 | E0499, E0597 | Directory traversal, sorting |
| `mkdir` | 200 | E0308 | Mode parsing, syscalls |
| `ln` | 300 | E0308, E0133 | Symlinks, path handling |

## Tier P2: Advanced

| Example | LOC | Primary Errors | Rationale |
|---------|-----|----------------|-----------|
| `sort` | 1500 | E0499, E0506 | Complex algorithms, callbacks |
| `uniq` | 250 | E0382 | Streaming, deduplication |
| `chmod` | 300 | E0308, E0133 | Bitwise ops, syscalls |
| `chown` | 250 | E0133 | Privilege, unsafe |
| `cut` | 400 | E0382, E0597 | Field parsing, lifetimes |
