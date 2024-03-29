#!/usr/bin/env bash
SCRIPTDIR="$(dirname "$(realpath "$0")")"

# Check that files exist first
FILES=("config.txt" "templates/compose.yaml.template")
for FILE in "${FILES[@]}"; do
    if [ ! -f "${SCRIPTDIR}/${FILE}" ]; then
            echo "File not found: ${FILE}"
            echo "Cannot continue. Exiting script."
            exit 1
    fi
done

# Then start by importing environment file
source "${SCRIPTDIR}"/config.txt

# Copy the docker compose files. Copy config.txt to .env
echo "Creating project: ${HOSTNAME}"
cp "${SCRIPTDIR}/templates/compose.yaml.template" "${SCRIPTDIR}/compose.yaml"
echo "Added file: compose.yaml"
cp "${SCRIPTDIR}/config.txt" "${SCRIPTDIR}/.env"
echo "Copied config.txt to .env"

# Create the docker network and management macvlan interface
echo '- - - - -'
echo "Creating docker network: ${HOSTNAME}"
docker network create -d macvlan --subnet=${SUBNET} --gateway=${GATEWAY} \
    --aux-address="mgmt_ip=${MGMTIP}" -o parent="${INTERFACE}" \
    --attachable "${HOSTNAME}"
echo "Creating management network: ${HOSTNAME::15}@${INTERFACE}"
sudo ip link add "${HOSTNAME::15}" link "${INTERFACE}" type macvlan mode bridge
sudo ip link set "${HOSTNAME::15}" up
sudo ip addr add "${MGMTIP}/32" dev "${HOSTNAME::15}"
sudo ip route add "${SUBNET}" dev "${HOSTNAME::15}"
echo "Added routes from management network to docker network"

# Start the project (containers plus network interface)
echo '- - - - -'
docker compose up -d
