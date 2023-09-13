#!/usr/bin/env bash
SCRIPTDIR="$(dirname "$(realpath "$0")")"

# Check that files exist first
FILES=("config.txt")
for FILE in "${FILES[@]}"; do
    if [ ! -f "${SCRIPTDIR}/${FILE}" ]; then
            echo "File not found: ${FILE}"
            echo "Cannot continue. Exiting script."
            exit 1
    fi
done

# Then start by importing environment file
source "${SCRIPTDIR}"/config.txt

# Copy config.txt to .env
echo "Creating container: ${HOSTNAME}"
cp "${SCRIPTDIR}/config.txt" "${SCRIPTDIR}/.env"
echo "Copied config.txt to .env"

# Create the docker network and management macvlan interface
echo '- - - - -'
echo "Creating docker network: ${INTERFACE}-macvlan"
docker network create -d macvlan --subnet=${SUBNET} --gateway=${GATEWAY} \
    --aux-address="mgmt_ip=${MGMTIP}" -o parent="${INTERFACE}" \
    --attachable "${INTERFACE}-macvlan"
echo "Creating management network: ${INTERFACE}-macvlan"
sudo ip link add "${INTERFACE}-macvlan" link "${INTERFACE}" type macvlan mode bridge
sudo ip link set "${INTERFACE}-macvlan" up
sudo ip addr add "${MGMTIP}/32" dev "${INTERFACE}-macvlan"
sudo ip route add "${SUBNET}" dev "${INTERFACE}-macvlan"
echo "Added routes from management network to docker network"

# Create the docker container
echo '- - - - -'
echo "Starting container: ${HOSTNAME}"
docker run -dit \
    --name "${HOSTNAME}" \
    --network "${INTERFACE}-macvlan" \
    --ip "${IPADDR}" \
    -h "${HOSTNAME}" \
    -e TZ="${TZ}" \
    -e HOSTNAME="${HOSTNAME}" \
    -e APPNAME="${APPNAME}" \
    "toddwint/${APPNAME}"
