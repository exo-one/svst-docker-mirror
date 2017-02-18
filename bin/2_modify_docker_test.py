#!/usr/bin/env python3

import yaml

docker_test_filename = 'docker-compose.test.yml'
docker_test = yaml.load(open(docker_test_filename, 'r'))

# This keeps containers ephemeral even when cached
del docker_test['services']['postgres']['volumes']
del docker_test['services']['ipfs']['volumes']
del docker_test['services']['bitcoind']['volumes']

docker_test['services']['bitcoind']['entrypoint'] = "sh -c 'btc_init && bitcoind -regtest'"

with open(docker_test_filename, 'w') as f:
    yaml.dump(docker_test, f)
print("Edited docker-compose.test.yml successfully")
