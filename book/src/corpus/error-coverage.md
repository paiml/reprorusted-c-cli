# Error Coverage Matrix

## Coverage Matrix

```
              E0506  E0499  E0382  E0308  E0133  E0597  E0515
P0 (8 ex)       2      2      3      4      0      1      1
P1 (6 ex)       1      2      2      2      3      1      0
P2 (5 ex)       1      1      2      2      2      1      0
Total           4      5      7      8      5      3      1
```

## Error Distribution

| Code | Description | % |
|------|-------------|---|
| E0506 | Cannot assign to borrowed | 31% |
| E0499 | Multiple mutable borrows | 21% |
| E0382 | Use after move | 16% |
| E0308 | Type mismatch | 10% |
| E0133 | Unsafe required | 7% |
| E0597 | Does not live long enough | 6% |
| E0515 | Cannot return reference | 5% |
