#!/bin/bash

version=$(curl -fsSL "https://api.github.com/repos/Tautulli/Tautulli/releases/latest" | jq -r .tag_name | sed s/v//g)
[[ -z ${version} ]] && exit
find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG TAUTULLI_VERSION=.*$/ARG TAUTULLI_VERSION=${version}/g" {} \;
sed -i "s/{TAG_VERSION=.*}$/{TAG_VERSION=${version}}/g" .drone.yml
echo "##[set-output name=version;]${version}"
