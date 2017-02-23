#!/bin/bash
docker-compose -f docker-compose.test.yml -p ci build --no-cache $@
