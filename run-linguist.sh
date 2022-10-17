

# only works if executed in the directory of the source code repo
github-linguist -b -j > res.json

python parse_liguist_json.py res.json

rm res.json
