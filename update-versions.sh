#!/bin/bash
set -exuo pipefail

git_branch="master"
response_json=$(curl -fsSL "https://api.github.com/repos/Tautulli/Tautulli/releases")
version=$(jq -re '.[0].tag_name' <<< "${response_json}")
prerelease=$(jq -r '.[0].prerelease' <<< "${response_json}")
[[ ${prerelease} == true ]] && git_branch="beta"
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg git_branch "${git_branch}" \
    '.version = $version | .git_branch = $git_branch' <<< "${json}" | tee meta.json
