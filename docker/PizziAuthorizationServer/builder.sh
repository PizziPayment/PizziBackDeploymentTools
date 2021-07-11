#!/usr/bin/env bash

(cd ./builder && ./setup_source.sh)

NPM_CACHE=pizzi-auth-npm-cache

IMAGE_TAG_TYPESCRIPT=pizzi-auth-builder-typescript
IMAGE_TAG_NPM_FETCHER=pizzi-auth-builder-npm-fetcher

(cd builder/typescript && docker build . -t $IMAGE_TAG_TYPESCRIPT)
(cd builder/npm-fetch && docker build . -t $IMAGE_TAG_NPM_FETCHER)

docker volume create $NPM_CACHE

docker run \
    -v $PWD/builder/typescript/sources:/sources \
    -v $PWD/runner/artefacts:/artefacts \
    -v $NPM_CACHE:/npm-cache \
    $IMAGE_TAG_TYPESCRIPT

docker run \
    -v $PWD/builder/npm-fetch/sources:/sources \
    -v $PWD/runner/artefacts:/artefacts \
    -v $NPM_CACHE:/npm-cache \
    $IMAGE_TAG_NPM_FETCHER
