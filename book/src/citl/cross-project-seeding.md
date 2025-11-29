# Cross-Project Seeding

Ownership errors are language-agnostic on the Rust side. Patterns from one transpiler can seed another.

## Transfer from depyler

```bash
decy oracle import \
    --from ~/.depyler/decision_patterns.apr \
    --filter "E0382,E0499,E0506,E0597,E0515" \
    --output decision_patterns.apr
```

## Transfer Matrix

| Error Code | Python→Rust | C→Rust | Notes |
|------------|-------------|--------|-------|
| E0382 | High | High | Move semantics universal |
| E0499 | Medium | High | C has more aliasing |
| E0506 | Medium | High | C mutation patterns differ |
| E0597 | High | High | Lifetime errors universal |
| E0308 | Low | High | Type systems differ |
| E0133 | None | High | C-specific unsafe |
