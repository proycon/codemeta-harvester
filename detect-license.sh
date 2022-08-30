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

for file in LICENSE LICENSE.md LICENSE.txt COPYING COPYRIGHT LICENCE LICENCE.md LICENCE.txt; do
    [ -e "$file" ] || continue;
    echo "Trying $file ...">&2
    TEXT=$(head -n 10 "$file" | tr "[:lower:]" "[:upper:]")
    case "$TEXT" in
        *"GNU LESSER GENERAL PUBLIC LICENSE"*|*"GNU LESSER GENERAL PUBLIC LICENCE"*)
            LICENSE="LGPL"
            ;;
        *"GNU AFFERO GENERAL PUBLIC LICENSE"*|*"GNU AFFERO GENERAL PUBLIC LICENCE"*)
            LICENSE="AGPL"
            ;;
        *"GNU GENERAL PUBLIC LICENSE"*|*"GNU GENERAL PUBLIC LICENCE"*)
            LICENSE="GPL"
            ;;
        *"APACHE LICENSE"*|*"APACHE LICENCE"*)
            LICENSE="Apache"
            ;;
        *"MIT LICENSE"*|*"MIT LICENCE"*)
            LICENSE="MIT"
            ;;
        *"ECLIPSE PUBLIC LICENSE"*|*"ECLIPSE PUBLIC LICENCE"*)
            LICENSE="EPL"
            ;;
        *"MOZILLA PUBLIC LICENSE"*|*"MOZILLA PUBLIC LICENCE"*)
            LICENSE="MPL"
            ;;
        *"EUROPEAN UNION PUBLIC LICENSE"*|*"EUROPEAN UNION PUBLIC LICENCE"*)
            LICENSE="EUPL"
            ;;
        *)
            LICENSE=""
            ;;
    esac

    case "$TEXT" in
        *"V3.0"*|*"VERSION 3.0"*|*"VERSION 3"*)
            VERSION="3.0"
            ;;
        *"V2.1"*|*"VERSION 2.1"*)
            VERSION="2.1"
            ;;
        *"V2.0"*|*"VERSION 2.0"*|*"VERSION 2"*)
            VERSION="2.0"
            ;;
        *"V1.1"*|*"VERSION 1.1"*)
            VERSION="1.1"
            ;;
        *"V1.0"*|*"VERSION 1.0"*|*"VERSION 1"*)
            VERSION="1.0"
            ;;
        *)
            VERSION=""
            ;;
    esac
    #shellch

    case "$TEXT" in
        *"OR ANY LATER VERSION"*)
            QUALIFIER="or-later"
            ;;
        *)
            QUALIFIER="only"
            ;;
    esac


    if [ -n "$LICENSE" ]; then
        if [ "$LICENSE" = "MIT" ]; then
            #no version
            echo "$LICENSE"
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

