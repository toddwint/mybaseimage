FROM ubuntu:jammy
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    HOSTNAME=mybaseimage \
    APPNAME=mybaseimage
RUN apt-get update \
    && \
    apt-get install -y \
    tzdata \
    iproute2 \
    iputils-ping \
    python3-minimal \
    tmux \
    wget \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    wget -q https://github.com/tsl0922/ttyd/releases/download/1.7.2/ttyd.x86_64 -O /usr/local/bin/ttyd \
    && \
    chmod 755 /usr/local/bin/ttyd \
    && \
    wget -q https://github.com/mthenw/frontail/releases/download/v4.9.1/frontail-linux -O /usr/local/bin/frontail \
    && \
    chmod 775 /usr/local/bin/frontail \
    && \
    gzip /usr/local/bin/frontail \
    && \
    wget -q https://github.com/gvalkov/tailon/releases/download/v1.1.0/tailon_1.1.0_linux_amd64.tar.gz -O /usr/local/bin/tailon_1.1.0_linux_amd64.tar.gz \
    && \
    tar -C /usr/local/bin -xvf /usr/local/bin/tailon_1.1.0_linux_amd64.tar.gz tailon \
    && \
    rm /usr/local/bin/tailon_1.1.0_linux_amd64.tar.gz \
    && \
    chmod 775 /usr/local/bin/tailon \
    && \
    gzip /usr/local/bin/tailon \
    && \
    apt-get remove -y \
    wget \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/
CMD ["bash"]
