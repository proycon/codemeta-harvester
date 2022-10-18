#!/bin/sh


# This script attempts to detect the continuous integration from standard input;
# it should passed the README.md file
# It will return a full URI

grep -o -E "(https://travis-ci.(org|com)/([A-Za-z0-9\-_]+)/([A-Za-z0-9\-_]+)|https://github.com/([A-Za-z0-9\-_]+)/([A-Za-z0-9\-_]+)/actions/(workflows/([A-Za-z0-9\-_]+)\\.(yml|yaml))?)" || exit 1

