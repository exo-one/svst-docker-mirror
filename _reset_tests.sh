docker pull exo1/dev-base-1
docker pull exo1/dev-base-haskell
docker pull exo1/dev-base-python
docker pull exo1/dev-test-bitcoind
docker-compose -f docker-compose.test.yml build --no-cache
docker-compose -f docker-compose.test.yml build --no-cache bitcoind
