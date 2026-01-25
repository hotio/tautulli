#!/bin/bash
set -exuo pipefail

version_branch="master"
response_json=$(curl -fsSL --header "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/repos/Tautulli/Tautulli/releases/latest")
version=$(jq -re '.tag_name' <<< "${response_json}")
prerelease=$(jq -r '.prerelease' <<< "${response_json}")
[[ ${prerelease} == true ]] && version_branch="beta"
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg version_branch "${version_branch}" \
    '.version = $version | .version_branch = $version_branch' <<< "${json}" | tee meta.json
