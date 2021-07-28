#!/usr/bin/env python3
import socket
import time

# ste urls for checks
urls = ('drive.google.com', 'mail.google.com', 'google.com')

# map IP
host_ips = dict()

while True:
    # for each url
    for url in urls:
        # get prev ip
        prev_ip = host_ips.get(url)
        # get curr ip
        curr_ip = socket.gethostbyname(url)
        host_ips[url] = curr_ip
        # if prev ip is set and prev_ip != curr_ip
        if prev_ip and prev_ip != curr_ip:
            # print error
            print(f'[ERROR] {url:20} IP mismatch: {prev_ip:20} {curr_ip}')
            continue
        print(f'{url:20} - {socket.gethostbyname(url)}')
    # will do it every 5 second
    time.sleep(5)
