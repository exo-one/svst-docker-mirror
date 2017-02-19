#!/bin/bash

docker pull exo1/dev-base-1
docker pull exo1/dev-base-haskell
docker pull exo1/dev-base-python
docker pull exo1/dev-test-bitcoind

docker-compose build --no-cache

