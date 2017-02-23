#!/usr/bin/env bash

set -e

goodtest=$(docker wait $(get_sut_container_id))  # wait for SUT container to finish

./_cleanup_tests.sh
echo "Test returned $goodtest"
exit "$goodtest"
