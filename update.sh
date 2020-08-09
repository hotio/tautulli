#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    mkdir ~/.docker && echo '{"experimental": "enabled"}' > ~/.docker/config.json
    image="hotio/base"
    tag="alpine"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm" and .platform.os == "linux").digest')   && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-arm-v7.Dockerfile && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
else
    data=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/Tautulli/Tautulli/releases")
    version=$(jq -r .[0].tag_name <<< "${data}" | sed s/v//g)
    [[ -z ${version} ]] && exit 1
    sed -i "s/{TAUTULLI_VERSION=[^}]*}/{TAUTULLI_VERSION=${version}}/g" .github/workflows/build.yml
    prerelease=$(jq -r .[0].prerelease <<< "${data}")
    if [[ ${prerelease} == true ]]; then
        sed -i "s/{TAUTULLI_BRANCH=[^}]*}/{TAUTULLI_BRANCH=beta}/g" .github/workflows/build.yml
    else
        sed -i "s/{TAUTULLI_BRANCH=[^}]*}/{TAUTULLI_BRANCH=master}/g" .github/workflows/build.yml
    fi
    echo "##[set-output name=version;]${version}"
fi
