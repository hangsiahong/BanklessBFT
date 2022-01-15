#!/bin/bash

cargo cov -- show \
    --use-color \
    --ignore-filename-regex='/rustc' \
    --ignore-filename-regex='/.cargo/registry' \
    --instr-profile=bankless_bft.profdata \
    --object target/debug/deps/bankless_bft-coverage \
    --show-instantiations --show-line-counts-or-regions \
    --Xdemangler=rustfilt | less -R
