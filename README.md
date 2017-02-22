# SVST Docker

This respository manages all docker files for the Secure Vote Stress Test

You will need a new version of `docker-compose` and `docker`.

## I just want to run it!

Run `1_auditor.sh` from this directory.

If you get stuck try running `2_refresh_all.sh` which will redownload
all base images and rebuild all containers.

### How do _you_ run it?

We (at Exo1) will run it using `1_producer.sh` - part of this involves providing the secret key used to sign headers.
Headers are only signed during the stress test as an anti-DoS measure, Secure.Vote itself will not use signed headers
(this would introduce a central authority).

## Codebase Organisation

The intended structure _for the 6 repositories_ is:

```
└── svst-docker
    ├── bitcoin-nulldata
    ├── stress-test-pallet-verification
    ├── svst-docs
    ├── svst-haskell
    └── svst-python
```

This allows the docker setup to copy the local files into Dockerfiles.

After cloning `svst-docker` you can use `_git_clone_all.sh` and `_git_pull_all.sh` for their respective git funcitons.

## Base Images

There are some base images we build other containers from. The main benefit is a common setup and caching.

* `dev-base-1` - this is the general base image, meant to include as many dev resources as possible
* `dev-base-haskell` - this is the base image for Haskell utils, based on dev-base-1. It has an out of date version of `svst-haskell`, however, stack has been upgraded and most libraries have cached prebuilt versions, so it's much faster to build on top of (rather than recompiling the same files over and over)
* `dev-base-python` - this is like the haskell image above and also based on dev-base-1. Since python doesn't need to compile much and a pip install is fast it is just an interim layer for convenience
* `dev-test-bitcoind` - a testing image used to skip over compiling bitcoind; not to be used in production

## Microservice images

In the `dockerfiles` subdirectory there are a number of folders with corresponding docker files.
These are responsible for building and running each individual service.

There are also a number of dockerfiles in the main directory.

Our microservices are:

* `bitcoind` (Bitcoin-Nulldata)
* `ipfs` (decentralised content network)
* `postgres` (database, for data-base-y things)
* `producer` (for producing nulldata, headers, and pallets)
* `scraper` (for scraping nulldata)
* `header-download` (for downloading and verifying pallet headers)
* `pallet-download` (for downloading pallets from verified headers)
* `pallet-verifier` (for verifying the signatures of pallets and the pallets themselves)
* `state-maker` (for calculating the state - essentially running through all valid pallets to count votes)
* `vote-explorer` (a simple html interface to explore votes and show the state of the network)

These are all started through the `docker-compose.yaml` files

## Volumes

We use volumes to make the docker images able to be used through all stages of the apps lifetime. All _state_ should be
stored in these folders, essentially.

* `bitcoind` uses `./bitcoind-data` to store `.bitcoin/` including configuration files and the main blockchain
* `ipfs` uses `./ipfs-data` to store _all_ downloaded pallets and headers (except invalid ones)
  * keep in mind, all IPFS chunks are stored here and the other services only download them via the API temporarily to
  verify / process them.
  * TODO: the haskell verifier might not actually do that. Not sure if we need to create a cludge or not
* `postgres` uses `./postgres-data` to store the DB files

## Development

Ideally you shouldn't need to touch `dev-base-1` or `dev-base-haskell`. For convenience the apt cache is left in, so if
you need any extra dependencies you can just add `apt-get install -y whatever` to the front of the particular docker file.

### Building Individual Images

Upon occasion you will need to rebuild a single image after changes have been
made upstream.

You will need to supply docker-compose with the instruction to build, to not
use the existing cached image as well as which image needs rebuilding:

    % docker-compose build --no-cache image_name

ie: rebuilding scraper:

    % docker-compose build --no-cache scraper

You can use `_rebuild_ci_container.sh` if you'd like to rebuild on for the testing framework.
Alternatively you can also run `_reset_tests.sh`

### Testing

Testing done through `docker-compose`'s testing framework.

See `.gitlab-ci.yml` for latest testing entrypoint and setup (in `run-tests`)

You can run tests manually with `_run_tests.sh`

If you need to rebuild all containers for CI run `_reset_tests.sh` - e.g. if you alter svst-haskell and need to re-compile

Use these scripts for various testing features:

* `_reset_tests.sh` - rebuild all test containers
* `_rebuild_ci_container.sh` - rebuild a single container (useful for testing a single container quickly)
* `_debug_btc` - run bitcoin-cli commands quickly
* `_cleanup_tests.sh` - stops all containers from CI
