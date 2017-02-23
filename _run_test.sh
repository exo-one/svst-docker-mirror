#!/bin/bash

set -e

bash ./_test_start.sh

until [[ ! -z $(get_sut_container_id) ]]; do
    echo "### waiting for SUT container ..."
    echo $(get_sut_container_id)
    sleep 10
done
echo "$$$ System Under Test (SUT) UP... executing docker wait"

docker ps

bash ./_test_end.sh
