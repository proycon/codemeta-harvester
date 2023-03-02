#!/bin/sh


# This script attempts to detect the technology readiness level from standard input;
# it should passed the README.md file
# It looks for stability badges (https://masterminds.github.io/stability/) and converts it (if possible)
# to a Technology Readiness Levels.
# It will return a full URI like https://w3id.org/research-technology-readiness-levels#Level9Proven
# Some things are better mapped to repostatus, it may return such URIs too 

set -e
BADGE=$(grep -o -E "https://masterminds.github.io/stability/[A-Za-z0-9]+.svg")
ID=$(basename "$BADGE" | sed "s/.svg//")
case "$ID" in
    experimental)
        echo "https://w3id.org/research-technology-readiness-levels#Stage3Experimental"
        ;;
    sustained|maintainance)
        echo "https://w3id.org/research-technology-readiness-levels#Stage4Complete"
        ;;
    active)
        echo "https://www.repostatus.org/#active"
        ;;
    unsupported)
        echo "https://www.repostatus.org/#unsupported"
        ;;
esac
