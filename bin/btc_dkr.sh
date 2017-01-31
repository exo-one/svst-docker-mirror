#!/bin/bash

ID=`docker ps | grep bitcoind | cut -d ' ' -f 1`
docker exec -ti $ID bitcoin-cli $@
