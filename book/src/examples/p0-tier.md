# P0 Tier (Trivial/Simple)

The P0 tier contains 8 baseline examples.

## yes (50 LOC)
**Primary Error**: E0308 - Simplest possible loop + I/O pattern.

## true / false (10 LOC)
**Primary Errors**: None - Baseline utilities that should compile clean.

## echo (80 LOC)
**Primary Error**: E0308 - String handling with argc/argv.

## cat (150 LOC)
**Primary Errors**: E0506, E0382 - File I/O with buffer management.

## wc (200 LOC)
**Primary Errors**: E0308, E0382 - Counting with state machines.

## head (180 LOC)
**Primary Errors**: E0597, E0515 - Line buffering with early exit.

## tail (350 LOC)
**Primary Errors**: E0499, E0506 - Ring buffer with complex state.
