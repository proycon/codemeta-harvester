#!/bin/sh

# This script attempts to detect some common documentation URLs from standard input
# it should passed the README.md file and will return URLs
grep -o -E '(https?://[a-z0-9_A-Z-]*.readthedocs.io/?|https?://docs.rs/[a-z0-9_A-Z-]*/?|https?://.*(documentation).*/)[^ >\)]*' | grep -v -E ".(svg|png|jpg)$" | sort | uniq || exit 1

