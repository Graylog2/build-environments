#!/bin/bash

sudo sv stop graylog-server
sudo sv stop elasticsearch
sudo sv stop mongodb
sudo pkill -f my_init
sudo pkill -f runsvdir
sudo pkill -f runsv
