#!/bin/sh

SCRIPTDIR="$(realpath "$(dirname "$0")")"

# only works if executed in the directory of the source code repo
github-linguist -b -j > tmp_codemetea_linguist_res.json

python $SCRIPTDIR/parse_liguist_json.py tmp_codemetea_linguist_res.json

rm tmp_codemetea_linguist_res.json
