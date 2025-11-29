# Training Workflow

## Bootstrap Protocol

```bash
# Phase 1: Transpile corpus
for example in examples/*/; do
    decy transpile "$example/original.c" --oracle --capture-patterns
done

# Phase 2: Aggregate patterns
decy citl aggregate training_corpus/

# Phase 3: Export oracle
decy oracle export --output decision_patterns.apr

# Phase 4: Validate
decy oracle validate decision_patterns.apr --min-patterns 100
```

## Makefile Targets

```bash
make citl-improve   # Full cycle
make citl-train     # Transpile and capture
make citl-export    # Export patterns
make citl-validate  # Validate quality
make citl-stats     # Show oracle stats
```
