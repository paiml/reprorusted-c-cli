# Why GNU Coreutils?

GNU coreutils is the canonical choice for C→Rust transpilation research.

## Advantages

| Criterion | Coreutils Advantage |
|-----------|---------------------|
| **Ubiquity** | Runs on every Linux system |
| **Code Quality** | Decades of maintenance, well-structured |
| **Pointer Diversity** | Heavy use of pointers, arrays, strings |
| **Error Surface** | Exercises all ownership error categories |
| **Prior Art** | Used in C2Rust, Laertes, other transpilers |

## Version Selection

```
Source: GNU coreutils 9.4
Release: 2023-08-29
URL: https://ftp.gnu.org/gnu/coreutils/coreutils-9.4.tar.xz
```

Pinning to a specific version ensures reproducibility and eliminates environmental flakiness.
