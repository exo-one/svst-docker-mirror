#!/bin/bash

( cd /root/bitcoin-nulldata && make -j 4 && make install && make clean) || (echo "Build failed!" && exit 1)
