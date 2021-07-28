
#!/usr/bin/env python3
import os
import argparse
import pathlib
import subprocess

aparser = argparse.ArgumentParser(
    description="Find modified files in repository"
)
# add rep_pwd argument
aparser.add_argument("rep_pwd", help="path to repository", type=pathlib.Path)
# parse args
args = aparser.parse_args()
# get abs path because in arg may be relative
abs_path = os.path.abspath(args.rep_pwd) + '/'

bash_command = [f"cd {abs_path}", "git status"]
# cd to repository and exec git status
result_os = os.popen(' && '.join(bash_command)).read()

# if stdout is empty - exit
if not result_os:
    print("Error - please check path to git repository")
    exit(1)

for result in result_os.split('\n'):
    # search modified files
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        # print abs path to modified file
        print(abs_path + os.path.basename(prepare_result))
