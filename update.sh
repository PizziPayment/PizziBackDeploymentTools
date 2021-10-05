#!/usr/bin/env bash
set -euo pipefail

GIT_URL="git@github.com:PizziPayment"

DB_REPO="$GIT_URL/PizziAPIBdd"
DB_BASE_DIR="PizziAPIBdd"
DB_REPO_BRANCH="master"

AUTH_SERVER_REPO="$GIT_URL/PizziAuthorizationServer"
AUTH_SERVER_BASE_DIR="PizziAuthorizationServer/builder/sources"
AUTH_SERVER_BRANCH="master"
AUTH_SERVER_DOCKER_RUNNER=pizzi-auth_runner

RSC_SERVER_REPO="$GIT_URL/PizziResourceServer"
RSC_SERVER_BASE_DIR="PizziResourceServer/builder/sources"
RSC_SERVER_BRANCH="master"
RSC_SERVER_DOCKER_RUNNER=pizzi-rsc_runner

export ARTEFACTS_UID=$(id -u)
export ARTEFACTS_GID=$(id -g)

########################
# Create repository for project or pull from it.
# Globals:
#   None
# Arguments:
#   project_dir: Path to which we clone
#   git_url: Url of the project (git@host:/path)
#   git_branch: Branch to clone
########################
fetch_projet_source() {
    if [[ $# -ne 3 ]]; then
        echo "Expected 3 arguments for fetch_projet_source(), got $#"
        exit 1
    fi

    local project_dir=$1
    local git_url=$2
    local git_branch=$3

    if [[ ! -d $project_dir ]]; then
        git clone -b $git_branch $git_url $project_dir
    else
        (cd $project_dir &&
            git fetch origin $git_branch
            git switch $git_branch
        )
    fi
}

########################
# Build the builder container for the specified project and run it to
# produce desired artifacts.
# Globals:
#   None
# Arguments:
#   build_dir: Path in which we do all our operations
#   image_tag: Name of the docker image to build and run
########################
build() {
    if [[ $# -ne 2 ]]; then
        echo "Expected 2 arguments for build_server(), got $#"
        exit 1
    fi

    local build_dir=$1
    local image_tag=$2

    local npm_cache_volume_name='pizzi-npm-cache'
    local npm_cache_volume='/npm-cache'

    cd $build_dir/builder

    # Fetch project dependencies
    npm --prefix ./sources install --production
    cp -r ./sources/node_modules ../runner/artefacts

    docker volume create $npm_cache_volume_name
    docker build . -t $image_tag

    docker run --rm \
      -v $PWD/../runner/artefacts:/artefacts \
      -v $npm_cache_volume_name:$npm_cache_volume \
      -e NPM_CACHE=$npm_cache_volume \
      -e ARTEFACTS_UID=$ARTEFACTS_UID \
      -e ARTEFACTS_GID=$ARTEFACTS_GID \
      -t $image_tag

    cd -
}

########################
# Build a docker container from the artifacts.
# Globals:
#   None
# Arguments:
#   build_dir: Path in which we do all our operations
#   image_tag: Name of the docker image to build and run
########################
build_runner() {
  if [[ $# -ne 2 ]]; then
    echo "Expected 2 arguments for build_runner(), got $#"
    exit 1
  fi

  local build_dir=$1
  local image_tag=$2

  cd $build_dir/runner

  docker build . -t $image_tag

  cd -
}

fetch_projet_source \
    $AUTH_SERVER_BASE_DIR \
    $AUTH_SERVER_REPO \
    $AUTH_SERVER_BRANCH
build \
    'PizziAuthorizationServer' \
    'pizzi-auth_builder'
build_runner \
    'PizziAuthorizationServer' \
    'pizzi-auth_runner'

fetch_projet_source \
    $RSC_SERVER_BASE_DIR \
    $RSC_SERVER_REPO \
    $RSC_SERVER_BRANCH
build \
    'PizziResourceServer' \
    'pizzi-rsc_builder'
build_runner \
    'PizziResourceServer' \
    'pizzi-rsc_runner'
