# Compiler-in-the-Loop Learning

CITL leverages compiler feedback to learn fix patterns automatically.

## How It Works

1. **Transpile** - Convert C to Rust (with errors)
2. **Compile** - Run rustc to get error messages
3. **Fix** - Query LLM for corrections
4. **Learn** - Index successful fixes as patterns
5. **Iterate** - Apply patterns before LLM queries

## The Oracle

The oracle is a pattern database stored as `.apr` files. When rustc reports an error:
1. Oracle checks for matching pattern
2. If found → Apply fix instantly (cost: $0)
3. If not found → Query LLM → Index result

## Benefits

| Metric | Without CITL | With CITL |
|--------|--------------|-----------|
| Cost per transpile | $0.05-0.50 | ~$0 steady state |
| Latency | 2-10s | <100ms |
| Consistency | Variable | Deterministic |
