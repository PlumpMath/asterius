#!/bin/sh -e

export ASTERIUS_BUILD_OPTIONS=-j8
export DEBIAN_FRONTEND=noninteractive
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export LC_CTYPE=C.UTF-8
export MAKEFLAGS=-j8
export PATH=/root/.local/bin:$PATH

echo 'deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20200224T000000Z sid main contrib non-free' > /etc/apt/sources.list

time apt update
apt full-upgrade -y
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
  zlib1g-dev
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo "deb https://deb.nodesource.com/node_13.x sid main" > /etc/apt/sources.list.d/nodesource.list
apt update
apt install -y nodejs

mkdir -p ~/.local/bin
curl -L https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-linux-x86_64.tar.gz | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack'
curl -L https://downloads.haskell.org/~cabal/cabal-install-3.0.0.0/cabal-install-3.0.0.0-x86_64-unknown-linux.tar.xz | tar xJ -C ~/.local/bin 'cabal'
mkdir ~/.stack
echo "allow-different-user: true" > ~/.stack/config.yaml

stack -j8 --no-terminal build --test --no-run-tests
stack --no-terminal exec ahc-boot

time stack --no-terminal test asterius:ghc-testsuite --test-arguments="-j8 --timeout=180s" || true
