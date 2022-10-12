#!/bin/sh

# This script attempts to detect the repostatus by looking at the git history
# we look at if there was a release (git tag using semanting versioning)
# and at what time the release or the latest git update to master/main was.
# if it's longer than three quarters of a year, we choose an inactive or suspended status

VERSION="$1" #explicitly passed version, will ignore git tags if set
NOW=$(date +%s)
TIMESTAMP_UPDATED=$(git log -1 --date=format:"%s" --format="%ad")
TIMESTAMP_LATEST_TAG=$(git log --date=format:"%s" --format="%ad %D" | grep -E "tag: v?[0-9]" | head -n 1 | cut -d " " -f 1)
THREEQYEARAGO=$((NOW - 23587200))  #three quarters of a year ago (273 days in seconds)
if [ -n "$TIMESTAMP_LATEST_TAG" ] || [ -n "$VERSION" ]; then
    #there have been releases
    if [ "$TIMESTAMP_UPDATED" -gt $THREEQYEARAGO ] || [ "$TIMESTAMP_LATEST_TAG" -gt $THREEQYEARAGO ]; then
        echo "https://www.repostatus.org/#active"
    else
        echo "https://www.repostatus.org/#inactive"
        #^-- might also be 'unsupported', but we give the benefit of the doubt and assign the weaker status
    fi
else
    #there have been no releases
    if [ "$TIMESTAMP_UPDATED" -gt $THREEQYEARAGO ]; then
        echo "https://www.repostatus.org/#wip"
    else
        echo "https://www.repostatus.org/#suspended"
        #^-- might also be 'abandoned', but we give the benefit of the doubt and assign the weaker status
    fi
fi
