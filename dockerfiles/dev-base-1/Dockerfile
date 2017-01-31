FROM ubuntu:xenial
MAINTAINER Max Kaye <max@exo1.tech>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e && \
    echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main" > /etc/apt/sources.list.d/bitcoin.list

RUN apt-get update
RUN apt-get install -y \
      wget git haskell-stack \
      build-essential libtool autotools-dev \
      autoconf pkg-config libssl-dev \
      libboost-all-dev libprotobuf-dev \
      protobuf-compiler libevent-dev sudo \
      nano bsdmainutils \
      software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update \
      && apt-get install -y libdb4.8-dev libdb4.8++-dev \
         postgresql-server-dev-9.5 libpq-dev 

# Add stuff after this so we have a common image