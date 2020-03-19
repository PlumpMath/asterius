FROM debian:sid

ARG DEBIAN_FRONTEND=noninteractive

ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  LC_CTYPE=C.UTF-8 \
  PATH=/home/asterius/.local/bin:${PATH}

RUN \
  echo 'deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20200224T000000Z sid main contrib non-free' > /etc/apt/sources.list && \
  apt update && \
  apt full-upgrade -y && \
  apt install -y \
    automake \
    cmake \
    curl \
    direnv \
    g++ \
    gawk \
    gcc \
    git \
    gnupg \
    libffi-dev \
    libgmp-dev \
    libncurses-dev \
    libnuma-dev \
    make \
    openssh-client \
    python3-pip \
    sudo \
    xz-utils \
    zlib1g-dev && \
  curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_13.x sid main" > /etc/apt/sources.list.d/nodesource.list && \
  apt update && \
  apt install -y nodejs && \
  useradd --create-home --shell /bin/bash asterius && \
  echo "asterius ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER asterius

WORKDIR /home/asterius

RUN \
  sudo rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
