#!/bin/bash

set -e

./bin/regen-docker-test.sh
docker-compose -f docker-compose.test.yml build --no-cache producer scraper header-download pallet-download pallet-verifier state-maker vote-explorer
docker-compose -f docker-compose.test.yml -p ci up --build -d
docker wait ci_sut_1
