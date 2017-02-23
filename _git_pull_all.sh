#!/bin/bash

source ./_git_repos.sh

gitroot="https://gitlab.com/exo-one"
if [[ -e $SVST_DEV ]]; then
  gitroot="git@gitlab.com:exo-one"
fi

for repo in ${repos[@]}; do
  cd "$repo" && git pull && cd ..
done
