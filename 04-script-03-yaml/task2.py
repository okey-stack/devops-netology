#!/usr/bin/env python3
import socket
import time

import json
import yaml

# path to files
path_to_file = "ips"

# ste urls for checks
urls = ('drive.google.com', 'mail.google.com', 'google.com')

# map IP
host_ips = dict()


# save data to yml or json
def save_file(file_name, file_ext, save_data):
    with open(f"{file_name}.{file_ext}", "w") as f:
        if file_ext == "yml":
            str_data = yaml.dump(save_data)
        elif file_ext == "json":
            str_data = json.dumps(save_data)
        f.write(str_data)


# format dict for work to dict for save
def prepare_data(formats_data):
    res = list(dict())
    # for each item
    for host, ip in formats_data.items():
        # add it in list as dict
        res.append({host: ip})

    return res


while True:
    # need save flag
    need_save = 0
    # for each url
    for url in urls:
        # get prev ip
        prev_ip = host_ips.get(url)
        # get curr ip
        curr_ip = socket.gethostbyname(url)
        host_ips[url] = curr_ip
        # if prev ip is set and prev_ip != curr_ip
        if prev_ip and prev_ip != curr_ip:
            # need save
            need_save = 1
            continue
        # save if first init
        if not prev_ip:
            need_save = 1

    if need_save:
        print("save")
        # if need save - save
        # to yml
        save_file("host_ips", "yml", prepare_data(host_ips))
        # and to jsonw
        save_file("host_ips", "json", prepare_data(host_ips))
    # will do it every 5 second
    time.sleep(5)
