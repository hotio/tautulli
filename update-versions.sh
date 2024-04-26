#!/bin/bash
git_branch="master"
response_json=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/Tautulli/Tautulli/releases/latest") || exit 1
version=$(jq -re '.tag_name' <<< "${response_json}")
[[ -z ${version} ]] && exit 0
[[ ${version} == null ]] && exit 0
prerelease=$(jq -r '.prerelease' <<< "${response_json}")
[[ ${prerelease} == true ]] && git_branch="beta"
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg git_branch "${git_branch}" \
    '.version = $version | .git_branch = $git_branch' <<< "${json}" | tee VERSION.json
