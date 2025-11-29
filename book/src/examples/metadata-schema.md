# Metadata Schema

Each example includes a `metadata.yaml` file.

## Per-Example Schema

```yaml
name: cat
source: GNU coreutils 9.4
commit: v9.4
license: GPL-3.0
tier: P0
loc: 150

functions:
  - name: cat_file
    lines: 42-89
    signature: "int cat_file(const char *filename)"
    complexity:
      cyclomatic: 8
      cognitive: 12
    expected_errors:
      - code: E0506
        count: 2
        pattern: "buffer mutation while borrowed"
```

## Required Fields

| Field | Description |
|-------|-------------|
| `name` | Utility name |
| `source` | Source project and version |
| `license` | Source license |
| `functions` | Array of function metadata |
| `expected_errors` | Anticipated rustc errors |
