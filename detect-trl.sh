#!/bin/sh


# This script attempts to detect the technology readiness level from standard input;
# it should passed the README.md file
# It will return a full URI like https://www.repostatus.org/#active
 
set -e
BADGE=$(grep -o -E "https://w3id.org/research-technology-readiness-levels/[A-Za-z0-9]+.svg")
ID=$(basename "$BADGE" | sed "s/.svg//")
echo "https://w3id.org/research-technology-readiness-levels#$ID"



