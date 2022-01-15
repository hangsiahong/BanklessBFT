#!/bin/bash

set -e

RUSTFLAGS="-Z instrument-coverage" \
    LLVM_PROFILE_FILE="bankless_bft-%m.profraw" \
    cargo +nightly test --tests $1 2> covtest.out

version=$(grep Running covtest.out | sed -e "s/.*bankless_bft-\(.*\))/\1/")
rm covtest.out
cp target/debug/deps/bankless_bft-"$version" target/debug/deps/bankless_bft-coverage

cargo profdata -- merge -sparse bankless_bft-*.profraw -o bankless_bft.profdata
rm bankless_bft-*.profraw

cargo cov -- report \
    --use-color \
    --ignore-filename-regex='/rustc' \
    --ignore-filename-regex='/.cargo/registry' \
    --instr-profile=bankless_bft.profdata \
    --object target/debug/deps/bankless_bft-coverage
