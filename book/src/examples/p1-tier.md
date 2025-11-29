# P1 Tier (Medium Complexity)

The P1 tier contains 6 medium-complexity utilities.

## cp (800 LOC)
**Primary Errors**: E0499, E0133 - Deep copy with permission bits.

## mv (600 LOC)
**Primary Errors**: E0382, E0506 - Move semantics.

## rm (400 LOC)
**Primary Errors**: E0133, E0382 - Recursive delete with unsafe.

## ls (1200 LOC)
**Primary Errors**: E0499, E0597 - Directory traversal with sorting.

## mkdir (200 LOC)
**Primary Error**: E0308 - Mode parsing with syscalls.

## ln (300 LOC)
**Primary Errors**: E0308, E0133 - Symlink handling.
