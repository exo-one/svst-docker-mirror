#!/bin/bash

set -e

export VERIFY_SECRET_KEY=1234567890123456789012345678901234567890123456789012345678901234
export VERIFY_PUBKEY=1234567890123456789012345678901234567890123456789012345678901234
export RESETDB=1

./bin/regen-docker-test.sh
docker-compose -f docker-compose.test.yml -p ci build --no-cache sut
docker-compose -f docker-compose.test.yml -p ci up --build &  # don't use -d for tests so we get all logs

goodtest=$(docker wait ci_sut_1)  # wait for SUT container to finish

./_cleanup_tests.sh
echo "$goodtest"
exit "$goodtest"
