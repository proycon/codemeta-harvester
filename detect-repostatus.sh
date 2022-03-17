#!/bin/sh


# This script attempts to detect the repostatus from standard input;
# it should passed the README.md file
# It will return a full URI like https://www.repostatus.org/#active

grep -o -E "https://www.repostatus.org/\#(active|inactive|wip|suspended|abandoned|unsupported|moved)" || exit 1
