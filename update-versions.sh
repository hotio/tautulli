#!/bin/bash

data=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/Tautulli/Tautulli/releases/latest")
version=$(jq -r .tag_name <<< "${data}" | sed s/v//g)
[[ -z ${version} ]] && exit 0
prerelease=$(jq -r .prerelease <<< "${data}")
if [[ ${prerelease} == true ]]; then
    branch=beta
else
    branch=master
fi
old_version=$(jq -r '.version' < VERSION.json)
changelog=$(jq -r '.changelog' < VERSION.json)
[[ "${old_version}" != "${version}" ]] && changelog="https://github.com/tautulli/tautulli/compare/v${old_version}...v${version}"
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .git_branch = "'"${branch}"'" | .changelog = "'"${changelog}"'"' <<< "${version_json}" > VERSION.json
