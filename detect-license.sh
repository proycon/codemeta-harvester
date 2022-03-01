#!/bin/sh

# This tool attempts to detect the license from the full license text
# and returns an SPDX identifier. It only supports a very limited set of common open source licenses

for file in README.md README.MD README.rst README README.txt README.TXT; do
    [ -e "$file" ] || continue;
    echo "Trying $file ...">&2
    SPDX=$(grep "SPDX-License-Identifier:" "$file" | sed -e 's/^.*SPDX-License-Identifier://')
    if [ -n "$SPDX" ]; then
        echo "$SPDX"
        exit 0
    fi
done

for file in LICENSE LICENSE.md COPYING COPYRIGHT; do
    [ -e "$file" ] || continue;
    echo "Trying $file ...">&2
    TEXT=$(head -n 10 "$file" | tr "[:lower:]" "[:upper:]")
    case "$TEXT" in
        *"GNU LESSER GENERAL PUBLIC LICENSE"*)
            LICENSE="LGPL"
            ;;
        *"GNU AFFERO GENERAL PUBLIC LICENSE"*)
            LICENSE="AGPL"
            ;;
        *"GNU GENERAL PUBLIC LICENSE"*)
            LICENSE="GPL"
            ;;
        *"APACHE LICENSE"*)
            LICENSE="Apache"
            ;;
        *"MIT LICENSE"*)
            LICENSE="MIT"
            ;;
        *"ECLIPE PUBLIC LICENSE"*)
            LICENSE="EPL"
            ;;
        *)
            LICENSE=""
            ;;
    esac

    case "$TEXT" in
        *"V3.0"*|*"VERSION 3.0"*|*"VERSION 3"*)
            VERSION="3.0"
            ;;
        *"V2.1"*|"VERSION 2.1"*)
            VERSION="2.1"
            ;;
        *"V2.0"*|*"VERSION 2.0"*|*"VERSION 2"*)
            VERSION="2.0"
            ;;
        *"V1.1"*|*"VERSION 1.1"*)
            VERSION="1.1"
            ;;
        *"v1.0"*|*"VERSION 1.0"*|*"VERSION 1"*)
            VERSION="1.0"
            ;;
        *)
            VERSION=""
            ;;
    esac

    case "$TEXT" in
        *"or any later version")
            QUALIFIER="or-later"
            ;;
        *)
            QUALIFIER="only"
            ;;
    esac


    if [ -n "$LICENSE" ]; then
        if [ "$LICENSE" == "MIT" ]; then
            #no version
            echo $LICENSE
            exit 0
        elif [ "$LICENSE" != "MIT" ] && [ -n "$VERSION" ]; then
            #version mandatory
            if [ "$LICENSE" = "GPL" ] || [ "$LICENSE" = "AGPL" ] || [ "$LICENSE" = "LGPL" ]; then
                echo "$LICENSE-$VERSION-$QUALIFIER"
            else
                echo "$LICENSE-$VERSION"
            fi
            exit 0
        fi
    fi
done

echo "No license detected" >&2
exit 1

