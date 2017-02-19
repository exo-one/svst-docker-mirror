#!/bin/bash

set -e

./bin/regen-docker-test.sh
docker-compose -f docker-compose.test.yml -p ci up --build -d
docker wait ci_sut_1
