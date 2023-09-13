---
title: README
date: 2023-09-13
---

# toddwint/mybaseimage


## Info

`mybaseimage` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/mybaseimage>

GitHub: <https://github.com/toddwint/mybaseimage>


## Overview

Docker image containing the features listed below and can be used as the base image for other images.

Pull the docker image from Docker Hub or, optionally, build the docker image from the source files in the `build` directory.

Create and run the container using `docker run` commands, `docker compose` commands, or by downloading and using the files here on github in the directories `run` or `compose`.

Example `docker run` and `docker compose` commands as well as sample commands to create the macvlan are below.


## Features

- Ubuntu base image
- Plus:
  - tmux
  - python3-minimal
  - iputils-ping
  - iproute2
  - tzdata
  - [ttyd](https://github.com/tsl0922/ttyd)
    - View the terminal in your browser
  - [frontail](https://github.com/mthenw/frontail)
    - View logs in your browser
    - Mark/Highlight logs
    - Pause logs
    - Filter logs
  - [tailon](https://github.com/gvalkov/tailon)
    - View multiple logs and files in your browser
    - User selectable `tail`, `grep`, `sed`, and `awk` commands
    - Filter logs and files
    - Download logs to your computer


## Sample commands to create the `macvlan`

Create the docker macvlan interface.

```bash
docker network create -d macvlan --subnet=192.168.10.0/24 --gateway=192.168.10.254 \
    --aux-address="mgmt_ip=192.168.10.2" -o parent="eth0" \
    --attachable "eth0-macvlan"
```

Create a management macvlan interface.

```bash
sudo ip link add "eth0-macvlan" link "eth0" type macvlan mode bridge
sudo ip link set "eth0-macvlan" up
```

Assign an IP on the management macvlan interface plus add routes to the docker container.

```bash
sudo ip addr add "192.168.10.2/32" dev "eth0-macvlan"
sudo ip route add "192.168.10.0/24" dev "eth0-macvlan"
```

## Sample `docker run` command

```bash
docker run -dit \
    --name "mybaseimage01" \
    --network "eth0-macvlan" \
    --ip "192.168.10.1" \
    -h "mybaseimage01" \
    -e TZ="UTC" \
    -e HOSTNAME="mybaseimage01" \
    -e APPNAME="mybaseimage" \
    "toddwint/mybaseimage"
```


## Sample `docker compose` (`compose.yaml`) file

```yaml
name: mybaseimage01

services:
  mybaseimage:
    image: toddwint/mybaseimage
    hostname: mybaseimage01
    networks:
        default:
            ipv4_address: 192.168.10.1
    environment:
        - HOSTNAME=mybaseimage01
        - TZ=UTC
        - APPNAME=mybaseimage
    tty: true

networks:
    default:
        name: "eth0-macvlan"
        external: true
```
