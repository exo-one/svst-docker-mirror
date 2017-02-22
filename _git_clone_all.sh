#!/bin/bash

source ./_git_repos.sh

gitroot="https://gitlab.com/exo-one"
if [[ -e $SVST_DEV ]]; then
  gitroot="git@gitlab.com:exo-one"
fi

currentbranch=$(git branch | grep '\*' | cut -d ' ' -f 2)

for repo in ${repos[@]}; do
  git clone "$gitroot/$repo"
  git checkout "$currentbranch"
done
