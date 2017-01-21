#!/bin/bash

( cd /root/bitcoin-nulldata && make -j 4 && make install) || (echo "Build failed!" && exit 1)
