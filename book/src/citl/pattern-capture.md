# Pattern Capture

When decy encounters a rustc error, it captures the context and fix for future use.

## Capture Format

```json
{
  "error_code": "E0382",
  "error_message": "use of moved value",
  "original_code": "let result = handle.read();",
  "fixed_code": "let result = handle.clone().read();",
  "fix_type": "clone_before_use",
  "confidence": 0.95
}
```

## Quality Filters

| Filter | Purpose |
|--------|---------|
| Compilation check | Fix must compile |
| Semantic check | Fix must preserve behavior |
| Generalization check | Pattern must be reusable |
| Confidence threshold | LLM confidence ≥0.8 |
