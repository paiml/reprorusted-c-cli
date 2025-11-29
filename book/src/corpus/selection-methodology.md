# Selection Methodology

Examples were selected based on error coverage, complexity gradient, real-world quality, and educational value.

## Academic Justification

| Criterion | Rationale | Citation |
|-----------|-----------|----------|
| Ubiquity | Code runs on every Linux system | Emre et al. 2021 |
| Code Quality | Decades of maintenance | Wheeler 2004 |
| Pointer Diversity | Heavy use of pointers, arrays, strings | Jung et al. 2018 |
| Error Surface | Exercises all ownership error categories | Astrauskas et al. 2019 |

## Curriculum Learning

The corpus follows curriculum learning principles (Bengio et al. 2009):

```
P0 (Week 0-1) ──► P1 (Week 2-3) ──► P2 (Week 4+)
   Trivial          Medium           Complex
```

Starting with simple examples allows for rapid iteration and early error detection.
