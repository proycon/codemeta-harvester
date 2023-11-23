#!/bin/sh
for file in $(find .); do #this is a bit fragile but it'll do
    case $file in
        .|..|./.*|*README*|*readme*|*license*|*LICENSE*|*licence*|*LICENCE*|*COPYING*|*MAINTAINERS*|*AUTHORS*|*CONTRIBUTORS*|*CITATION*|*cff|*codemeta*json|*.png|*.svg|*.jpg|*.webp|*.webm|*.md|*.rst)
            #these files are considered 'meta' and not sourcecode
            ;;
        *)
            echo "not a stub ($file)">&2
            #any other file means we're not a stub repo
            exit 0
    esac
done
echo "repository seems to be a stub" >&2
exit 1

