#!/usr/bin/env bash

# This file is for avoiding doing a build on most containers.
# It will pass the first argument through to ./_rebuild_ci_container.sh and then run test without any other rebuilds

./_cleanup_tests.sh &
./_rebuild_ci_container.sh $@ &
./_rebuild_ci_container.sh sut &
wait

export VERIFY_SECRET_KEY=1234567890123456789012345678901234567890123456789012345678901234
export VERIFY_PUBKEY=c9df7bcba2238bedcc681e8b17bb21c1625d21d285b70c20cf53fdd473db9dfb

function get_sut_container_id {
    docker ps | grep "ci_sut" | cut -d ' ' -f 1
}

docker-compose -f docker-compose.test.yml -p ci up &  # don't use -d for tests so we get all logs

until [[ ! -z $(get_sut_container_id) ]]; do
    echo "### waiting for SUT container ..."
    echo $(get_sut_container_id)
    sleep 10
done
echo "$$$ System Under Test (SUT) UP... executing docker wait"

docker ps
goodtest=$(docker wait $(get_sut_container_id))  # wait for SUT container to finish

./_cleanup_tests.sh
echo "Test returned $goodtest"
exit "$goodtest"
