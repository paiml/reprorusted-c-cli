#!/usr/bin/env bash
# Corpus validation script for reprorusted-c-cli
# EXTREME TDD: These tests define the acceptance criteria from examples-spec.md
set -uo pipefail
# Note: -e removed to allow test failures to accumulate

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EXAMPLES_DIR="$PROJECT_ROOT/examples"

# Counters
PASS=0
FAIL=0
TOTAL=0

# Test utilities
pass() {
    echo -e "${GREEN}✓${NC} $1"
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
}

section() {
    echo ""
    echo -e "${YELLOW}═══ $1 ═══${NC}"
}

# P0 tier utilities (trivial/simple)
P0_UTILS=("yes" "true" "false" "echo" "cat" "wc" "head" "tail")

# P1 tier utilities (medium complexity)
P1_UTILS=("cp" "mv" "rm" "ls" "mkdir" "ln")

# P2 tier utilities (advanced)
P2_UTILS=("sort" "uniq" "chmod" "chown" "cut")

ALL_UTILS=("${P0_UTILS[@]}" "${P1_UTILS[@]}" "${P2_UTILS[@]}")

# Expected error codes per spec section 2.2
declare -A EXPECTED_ERRORS
EXPECTED_ERRORS[yes]="E0308"
EXPECTED_ERRORS[true]=""
EXPECTED_ERRORS[false]=""
EXPECTED_ERRORS[echo]="E0308"
EXPECTED_ERRORS[cat]="E0506,E0382"
EXPECTED_ERRORS[wc]="E0308,E0382"
EXPECTED_ERRORS[head]="E0597,E0515"
EXPECTED_ERRORS[tail]="E0499,E0506"
EXPECTED_ERRORS[cp]="E0499,E0133"
EXPECTED_ERRORS[mv]="E0382,E0506"
EXPECTED_ERRORS[rm]="E0133,E0382"
EXPECTED_ERRORS[ls]="E0499,E0597"
EXPECTED_ERRORS[mkdir]="E0308"
EXPECTED_ERRORS[ln]="E0308,E0133"
EXPECTED_ERRORS[sort]="E0499,E0506"
EXPECTED_ERRORS[uniq]="E0382"
EXPECTED_ERRORS[chmod]="E0308,E0133"
EXPECTED_ERRORS[chown]="E0133"
EXPECTED_ERRORS[cut]="E0382,E0597"

#############################################
# TEST: Directory Structure (Spec Section 8)
#############################################
section "Directory Structure Tests"

# Test examples directory exists
if [[ -d "$EXAMPLES_DIR" ]]; then
    pass "examples/ directory exists"
else
    fail "examples/ directory missing"
fi

# Test all 19 example directories exist
for util in "${ALL_UTILS[@]}"; do
    dir="$EXAMPLES_DIR/coreutils_$util"
    if [[ -d "$dir" ]]; then
        pass "Directory exists: coreutils_$util"
    else
        fail "Directory missing: coreutils_$util"
    fi
done

#############################################
# TEST: Metadata Files (Spec Section 3.1)
#############################################
section "Metadata File Tests"

for util in "${ALL_UTILS[@]}"; do
    metadata_file="$EXAMPLES_DIR/coreutils_$util/metadata.yaml"
    if [[ -f "$metadata_file" ]]; then
        pass "Metadata exists: coreutils_$util/metadata.yaml"

        # Validate required fields per spec 3.1
        if grep -q "^name:" "$metadata_file" 2>/dev/null; then
            pass "  Has 'name' field"
        else
            fail "  Missing 'name' field"
        fi

        if grep -q "^source:" "$metadata_file" 2>/dev/null; then
            pass "  Has 'source' field"
        else
            fail "  Missing 'source' field"
        fi

        if grep -q "^license:" "$metadata_file" 2>/dev/null; then
            pass "  Has 'license' field"
        else
            fail "  Missing 'license' field"
        fi

        if grep -q "^functions:" "$metadata_file" 2>/dev/null; then
            pass "  Has 'functions' field"
        else
            fail "  Missing 'functions' field"
        fi

        # Check expected_errors if utility should have them
        expected="${EXPECTED_ERRORS[$util]}"
        if [[ -n "$expected" ]]; then
            if grep -q "expected_errors:" "$metadata_file" 2>/dev/null; then
                pass "  Has 'expected_errors' section"
            else
                fail "  Missing 'expected_errors' section (expected: $expected)"
            fi
        fi
    else
        fail "Metadata missing: coreutils_$util/metadata.yaml"
    fi
done

#############################################
# TEST: Tier Breakdown (Spec Section 2.1)
#############################################
section "Tier Breakdown Tests"

# Count P0 examples
p0_count=0
for util in "${P0_UTILS[@]}"; do
    if [[ -d "$EXAMPLES_DIR/coreutils_$util" ]] && [[ -f "$EXAMPLES_DIR/coreutils_$util/metadata.yaml" ]]; then
        p0_count=$((p0_count + 1))
    fi
done
if [[ $p0_count -eq 8 ]]; then
    pass "P0 tier has 8 examples"
else
    fail "P0 tier has $p0_count examples (expected 8)"
fi

# Count P1 examples
p1_count=0
for util in "${P1_UTILS[@]}"; do
    if [[ -d "$EXAMPLES_DIR/coreutils_$util" ]] && [[ -f "$EXAMPLES_DIR/coreutils_$util/metadata.yaml" ]]; then
        p1_count=$((p1_count + 1))
    fi
done
if [[ $p1_count -eq 6 ]]; then
    pass "P1 tier has 6 examples"
else
    fail "P1 tier has $p1_count examples (expected 6)"
fi

# Count P2 examples
p2_count=0
for util in "${P2_UTILS[@]}"; do
    if [[ -d "$EXAMPLES_DIR/coreutils_$util" ]] && [[ -f "$EXAMPLES_DIR/coreutils_$util/metadata.yaml" ]]; then
        p2_count=$((p2_count + 1))
    fi
done
if [[ $p2_count -eq 5 ]]; then
    pass "P2 tier has 5 examples"
else
    fail "P2 tier has $p2_count examples (expected 5)"
fi

# Total check
total_examples=$((p0_count + p1_count + p2_count))
if [[ $total_examples -eq 19 ]]; then
    pass "Total corpus has 19 examples"
else
    fail "Total corpus has $total_examples examples (expected 19)"
fi

#############################################
# TEST: Error Coverage Matrix (Spec Section 2.2)
#############################################
section "Error Code Coverage Tests"

# All 7 major error codes must be represented
ERROR_CODES=("E0506" "E0499" "E0382" "E0308" "E0133" "E0597" "E0515")

for code in "${ERROR_CODES[@]}"; do
    found=0
    for util in "${ALL_UTILS[@]}"; do
        metadata_file="$EXAMPLES_DIR/coreutils_$util/metadata.yaml"
        if [[ -f "$metadata_file" ]] && grep -q "$code" "$metadata_file" 2>/dev/null; then
            found=$((found + 1))
        fi
    done
    if [[ $found -gt 0 ]]; then
        pass "Error code $code covered ($found examples)"
    else
        fail "Error code $code not covered (0 examples)"
    fi
done

#############################################
# TEST: Corpus Metadata (Spec Section 3.2)
#############################################
section "Corpus Metadata Tests"

CORPUS_META="$PROJECT_ROOT/corpus_metadata.yaml"
if [[ -f "$CORPUS_META" ]]; then
    pass "corpus_metadata.yaml exists"

    if grep -q "^version:" "$CORPUS_META" 2>/dev/null; then
        pass "  Has 'version' field"
    else
        fail "  Missing 'version' field"
    fi

    if grep -q "source:.*coreutils" "$CORPUS_META" 2>/dev/null; then
        pass "  Source is GNU coreutils"
    else
        fail "  Missing or incorrect source"
    fi

    if grep -q "total_examples: 19" "$CORPUS_META" 2>/dev/null; then
        pass "  Total examples is 19"
    else
        fail "  Total examples incorrect or missing"
    fi

    if grep -q "error_distribution:" "$CORPUS_META" 2>/dev/null; then
        pass "  Has error_distribution section"
    else
        fail "  Missing error_distribution section"
    fi
else
    fail "corpus_metadata.yaml missing"
fi

#############################################
# TEST: Source Files (Spec Section 8)
#############################################
section "Source File Tests (original.c)"

for util in "${ALL_UTILS[@]}"; do
    source_file="$EXAMPLES_DIR/coreutils_$util/original.c"
    if [[ -f "$source_file" ]]; then
        pass "Source exists: coreutils_$util/original.c"

        # Check file is not empty
        if [[ -s "$source_file" ]]; then
            pass "  File is non-empty"
        else
            fail "  File is empty"
        fi

        # Check it looks like C code
        if grep -q "#include" "$source_file" 2>/dev/null; then
            pass "  Contains #include directive"
        else
            fail "  Missing #include directive (not valid C)"
        fi
    else
        fail "Source missing: coreutils_$util/original.c"
    fi
done

# Count source files
source_count=0
for util in "${ALL_UTILS[@]}"; do
    if [[ -f "$EXAMPLES_DIR/coreutils_$util/original.c" ]]; then
        source_count=$((source_count + 1))
    fi
done
if [[ $source_count -eq 19 ]]; then
    pass "All 19 original.c files present"
else
    fail "Only $source_count/19 original.c files present"
fi

#############################################
# SUMMARY
#############################################
echo ""
echo "═══════════════════════════════════════"
echo -e "Total: $TOTAL | ${GREEN}Passed: $PASS${NC} | ${RED}Failed: $FAIL${NC}"
echo "═══════════════════════════════════════"

if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}All validation tests passed!${NC}"
    exit 0
else
    echo -e "${RED}$FAIL tests failed. Corpus incomplete.${NC}"
    exit 1
fi
