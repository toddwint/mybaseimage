#!/usr/bin/env bash
APPNAME=mybaseimage
source "$(dirname "$(dirname "$(realpath $0)")")"/config.txt
docker exec -it "$HOSTNAME" tmux kill-session -t "$APPNAME"
