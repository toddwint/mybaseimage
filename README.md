# toddwint/mybaseimage

## Info

`mybaseimage` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/mybaseimage>

GitHub: <https://github.com/toddwint/mybaseimage>


## Features

- Ubuntu base image
- Plus:
  - tmux
  - python3-minimal
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


## Sample `config.txt` file

```
TZ=UTC
IPADDR=127.0.0.1
HTTPPORT1=8080
HTTPPORT2=8081
HTTPPORT3=8082
HOSTNAME=mybaseimagesrvr01
```


## Sample docker run script

```
#!/usr/bin/env bash
REPO=toddwint
APPNAME=mybaseimage
source "$(dirname "$(realpath $0)")"/config.txt

# Create the docker container
docker run -dit \
    --name "$HOSTNAME" \
    --network host \
    -h "$HOSTNAME" \
    -v "$HOSTNAME":/opt/"$APPNAME"/logs \
    -p "$IPADDR":"$HTTPPORT1":"$HTTPPORT1" \
    -p "$IPADDR":"$HTTPPORT2":"$HTTPPORT2" \
    -p "$IPADDR":"$HTTPPORT3":"$HTTPPORT3" \
    -e TZ="$TZ" \
    -e HTTPPORT1="$HTTPPORT1" \
    -e HTTPPORT2="$HTTPPORT2" \
    -e HTTPPORT3="$HTTPPORT3" \
    -e HOSTNAME="$HOSTNAME" \
    -e APPNAME="$APPNAME" \
    ${REPO}/${APPNAME}
```


## Login page

Open the `webadmin.html` file.

- Or just type in your browser: 
  - `http://<ip_address>:<port1>` or
  - `http://<ip_address>:<port2>` or
  - `http://<ip_address>:<port3>`


## Issues?

Make sure to set the IP on the host and that the ports being used are not currently being used by the host.