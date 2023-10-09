# -*- coding: utf-8 -*-
import json
import os
import sys
import magic   # python-magic dependency, maybe use other internals instead
from pathlib import Path
from typing import Tuple

mime = magic.Magic(mime=True)


# execute github-linguist (https://github.com/github/linguist)
# there is also a python package for it, but it is not maintained any more since
# 2020ish, also I could not make it work 
# https://github.com/douban/linguist
def process_linguist(lg_json_path: Path, save_path: Path='linguist.codemeta.json', richmeta: bool=False) -> None:
    """_summary_

    :param lg_json_path: _description_
    :type lg_json_path: Path
    :param save_path: _description_, defaults to 'codemeta-linguist.json'
    :type save_path: str, optional
    """
    with open(lg_json_path, 'r') as fileo:
        lg_json = json.load(fileo)

    code_meta_keys, additional_metadata = parse_json_linguist(lg_json=lg_json)
    
    if richmeta:
        code_meta_keys.update(additional_metadata)

    with open(save_path, 'w') as fileo:
        json.dump(code_meta_keys, fileo)


def parse_json_linguist(lg_json: dict, repo_path: Path='.') -> Tuple[dict, dict]:
    """Parse the output json of github linguist into a valid codemeta.json snippet.

    Since this information is not enough, additional parsing of information from
    the files in the repository is performed and a dictionary of additional metadata
    returned.

    :param lg_json_path: _description_
    :type lg_json_path: Path
    :param repo_path: _description_
    :type repo_path: Path
    :return: _description_
    :rtype: _type_
    """

    # linguist gives the file size in Blocks, not in bytes.
    # same as ls output... Also linguist does not detect all files.


    total_size_blocks = 0
    langs = []
    lang_percent = []
    for key, val in lg_json.items():
        print(key, val)
        # ordered by size
        langs.append(key)
        total_size_blocks = total_size_blocks + val['size']
        lang_percent.append(val['percentage'])
        # percentage is in block size...
    
    total_size = 0
    file_formats = []
    fileends = []
    # get total size, of repo, slow but works
    for path, dirs, files in os.walk(repo_path):
        for fil in files:
            fp = os.path.join(path, fil)
            total_size += os.path.getsize(fp)
            file_formats.append(mime.from_file(fp))
            ext = os.path.splitext(fil)[1]
            if len(ext) > 0:
                fileends.append(ext)
    total_size = int(total_size / 1024.0) # byte to KB
    code_meta_keys =  {"programmingLanguage" : langs,
     "fileFormat" : list(set(file_formats)), # mime type
     "fileSize" : f"{total_size}KB"}
    
    additional_metadata =  {
       "programmingLanguagePercentageSize" : lang_percent,
       "fileEndings" : list(set(fileends))
       }
    
    return code_meta_keys, additional_metadata
    
if __name__ == "__main__":
    path = sys.argv[1]
    process_linguist(lg_json_path=path)
