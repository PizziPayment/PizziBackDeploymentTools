#!/usr/bin/env bash
set -euo pipefail

DB_BASE_DIR=PizziAPIBdd
AUTH_SERVER_BASE_DIR=PizziAuthorizationServer
RES_SERVER_BASE_DIR=PizziResourceServer

chown_file() {
    local file=$1

    if [[ -f $file ]]; then
        set -x
        sudo chown $(id -u):$(id -g) $file
        set +x
    fi
}

remove_project_sources() {
    echo "Remove $1 sources"

    chown_file $1/builder/npm-fetch/sources/package-lock.json
    chown_file $1/builder/typescript/sources/package-lock.json

    rm -rf \
        $1/builder/npm-fetch/sources/node_modules \
        $1/builder/npm-fetch/sources/package.json \
        $1/builder/npm-fetch/sources/package-lock.json \
        $1/builder/sources \
        $1/builder/typescript/sources/app \
        $1/builder/typescript/sources/dist \
        $1/builder/typescript/sources/node_modules \
        $1/builder/typescript/sources/package.json \
        $1/builder/typescript/sources/package-lock.json \
        $1/builder/typescript/sources/tsconfig.json
}

remove_project_artefacts() {
    echo "Remove $1 artefacts"
    set -x
    sudo rm -rf \
        $1/runner/artefacts/dist \
        $1/runner/artefacts/node_modules
    set +x
}

remove_project_sources $AUTH_SERVER_BASE_DIR
remove_project_sources $RES_SERVER_BASE_DIR

remove_project_artefacts $AUTH_SERVER_BASE_DIR
remove_project_artefacts $RES_SERVER_BASE_DIR

rm -rf $DB_BASE_DIR/sources
