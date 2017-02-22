#!/bin/bash

source ./_git_repos.sh

gitroot="https://gitlab.com/exo-one"
if [[ -e $SVST_DEV ]]; then
  gitroot="git@gitlab.com:exo-one"
fi

for repo in ${repos[@]}; do
  git clone "$gitroot/$repo"
  if [[ -e $1 ]]; then
    cd "$repo"
    git checkout "$1"
    echo "Checking out $1"
    cd ..
  fi
done
