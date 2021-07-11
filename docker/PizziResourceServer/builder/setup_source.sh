#!/usr/bin/env bash

echo "Setup sources for typescript and npm-fetch"

chown_file() {
    local file=$1

    if [[ -f $file ]]; then
        set -x
        sudo chown $(id -u):$(id -g) $file
        set +x
    fi
}

chown_file ./npm-fetch/sources/package-lock.json
chown_file ./typescript/sources/package-lock.json

cp -r \
    ./sources/app \
    ./sources/tsconfig.json \
    ./sources/package.json \
    ./sources/package-lock.json \
    ./typescript/sources

cp \
    ./sources/package.json \
    ./sources/package-lock.json \
    ./npm-fetch/sources
