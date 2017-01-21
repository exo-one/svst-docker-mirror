#!/bin/bash

mkdir -p /root/build
cd /root/build
tar -xf /root/db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix
../dist/configure --disable-shared --enable-cxx --with-pic
make install
