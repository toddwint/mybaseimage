FROM ubuntu:jammy
ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    HOSTNAME=mybaseimage \
    APPNAME=mybaseimage
RUN apt-get update \
    && \
    apt-get install -y \
    fzf \
    iproute2 \
    iputils-ping \
    python3-minimal \
    tmux \
    tzdata \
    wget \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    wget -O /usr/local/bin/ttyd -q https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.$(arch) \
    && \
    chmod 755 /usr/local/bin/ttyd \
    && \
    wget -O /usr/local/bin/frontail -q https://github.com/mthenw/frontail/releases/download/v4.9.1/frontail-linux \
    && \
    chmod 775 /usr/local/bin/frontail \
    && \
    gzip /usr/local/bin/frontail \
    && \
    wget -O /usr/local/bin/tailon.tar.gz -q https://github.com/gvalkov/tailon/releases/download/v1.1.0/tailon_1.1.0_linux_$TARGETARCH.tar.gz \
    && \
    tar -C /usr/local/bin -xvf /usr/local/bin/tailon.tar.gz tailon \
    && \
    rm /usr/local/bin/tailon.tar.gz \
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
