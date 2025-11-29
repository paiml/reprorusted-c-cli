# Iterative Improvement

The CITL oracle improves with each training cycle.

## Metrics Over Time

| Iteration | Patterns | LLM Queries | Success Rate |
|-----------|----------|-------------|--------------|
| 1 | 0 | 100% | - |
| 2 | 50 | 60% | 65% |
| 3 | 120 | 30% | 78% |
| 4 | 180 | 15% | 85% |
| 5+ | 200+ | <10% | 90%+ |

## Convergence

The oracle converges when:
- LLM query rate drops below 10%
- Success rate exceeds 85%
- New patterns per iteration < 5

At steady state, transpilation is fast, free, and deterministic.
