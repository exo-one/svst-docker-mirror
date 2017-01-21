#!/bin/bash

( cd /root/bitcoin-nulldata && \
  ./autogen.sh && \
  export BDB_PREFIX=/usr/local/BerkeleyDB.4.8 && \
    ./configure --without-gui --without-miniupnpc CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" \
    LDFLAGS="-L${BDB_PREFIX}/lib/" ) || (echo "Config failed!" && exit 1)
