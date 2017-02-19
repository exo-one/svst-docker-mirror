#!/bin/bash

set -e

export VERIFY_SECRET_KEY=1234567890123456789012345678901234567890123456789012345678901234
export VERIFY_PUBKEY=1234567890123456789012345678901234567890123456789012345678901234

./bin/regen-docker-test.sh
docker-compose -f docker-compose.test.yml -p ci build --no-cache sut
docker-compose -f docker-compose.test.yml -p ci up --build &  # don't use -d for tests so we get all logs

sleep 10
docker ps
goodtest=$(docker wait $(docker ps | grep "ci_sut" | cut -d ' ' -f 1))  # wait for SUT container to finish

./_cleanup_tests.sh
echo "$goodtest"
exit "$goodtest"
