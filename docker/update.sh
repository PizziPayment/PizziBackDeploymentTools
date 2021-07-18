#!/usr/bin/env bash
set -euo pipefail

GIT_USER="git"
GIT_URL="$GIT_USER@github.com:PizziPayment"

DB_REPO="$GIT_URL/PizziAPIBdd"
DB_BASE_DIR="PizziAPIBdd"
DB_REPO_BRANCH="master"

AUTH_REPO="$GIT_URL/PizziAuthorizationServer"
AUTH_SERVER_BASE_DIR="PizziAuthorizationServer"
AUTH_SERVER_REPO_BRANCH="master"

RSC_REPO="$GIT_URL/PizziResourceServer"
RSC_SERVER_BASE_DIR="PizziResourceServer"
RSC_SERVER_REPO_BRANCH="master"

fetch_projet_source() {
    local project_dir=$1
    local git_url=$2
    local git_branch=$3

    if [[ ! -d $project_dir ]]; then
        git clone -b $git_branch $git_url $project_dir
    else
        (cd $project_dir && git pull origin $git_branch)
    fi
}

fetch_projet_source \
    $AUTH_SERVER_BASE_DIR/builder/sources \
    $AUTH_REPO \
    $AUTH_SERVER_REPO_BRANCH
(cd $AUTH_SERVER_BASE_DIR && ./builder.sh && ./runner.sh)

fetch_projet_source \
    $RSC_SERVER_BASE_DIR/builder/sources \
    $RSC_REPO \
    $RSC_SERVER_REPO_BRANCH
(cd $RSC_SERVER_BASE_DIR && ./builder.sh && ./runner.sh)

fetch_projet_source \
    $DB_BASE_DIR/sources \
    $DB_REPO \
    $DB_REPO_BRANCH
