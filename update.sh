#!/usr/bin/env bash
set -euo pipefail

GIT_URL="git@github.com:PizziPayment"

DEPLOY_REPO="$GIT_URL/DeployDB"
DEPLOY_BASE_DIR="PizziDeploy/sources"
DEPLOY_BRANCH="main"

AUTH_SERVER_REPO="$GIT_URL/PizziAuthorizationServer"
AUTH_SERVER_BASE_DIR="PizziAuthorizationServer/sources"
AUTH_SERVER_BRANCH="master"

RSC_SERVER_REPO="$GIT_URL/PizziResourceServer"
RSC_SERVER_BASE_DIR="PizziResourceServer/sources"
RSC_SERVER_BRANCH="develop"

REPO_ROOT_FOLDER=$(git rev-parse --show-toplevel)

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
            git switch $git_branch
            git pull origin $git_branch
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
########################
build() {
    if [[ $# -ne 1 ]]; then
        echo "Expected 1 arguments for build_server(), got $#"
        exit 1
    fi
    local build_dir=$1

    local cwd=$(pwd)
    local yarn_cache_folder="$REPO_ROOT_FOLDER/.yarn/cache"

    cd $build_dir

    # Fetch production project dependencies
    cd sources
    yarn config unset cacheFolder
    yarn workspaces focus --all --production
    cp -r ".yarn/cache" '../runner/artefacts/.yarn/'
    cp '.pnp.cjs' '../runner/artefacts'

    # Compile typescript
    mkdir -p "$yarn_cache_folder"
    yarn config set cacheFolder "$yarn_cache_folder"
    yarn install
    echo "Compiling typescript"
    yarn run build
    cp -r dist ../runner/artefacts
    cd ..

    cp sources/config/{custom-environment-variables.json,default.json} \
        runner/artefacts/config

    cd "$cwd"
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

########################
# Build a Docker container to run the migration.
# Globals:
#   None
# Arguments:
#   build_dir: Path in which we do all our operations
#   image_tag: Name of the docker image to build and run
########################
build_db_migrations() {
  if [[ $# -ne 2 ]]; then
    echo "Expected 2 arguments for build_runner(), got $#"
    exit 1
  fi

  local build_dir=$1
  local image_tag=$2

  cd $build_dir

  (cd "sources" && yarn install)
  docker build . -t $image_tag

  cd -
}

fetch_projet_source \
    $AUTH_SERVER_BASE_DIR \
    $AUTH_SERVER_REPO \
    $AUTH_SERVER_BRANCH
build \
    'PizziAuthorizationServer'
build_runner \
    'PizziAuthorizationServer' \
    'pizzi-auth-runner'

fetch_projet_source \
    $RSC_SERVER_BASE_DIR \
    $RSC_SERVER_REPO \
    $RSC_SERVER_BRANCH
build \
    'PizziResourceServer'
build_runner \
    'PizziResourceServer' \
    'pizzi-rsc-runner'

fetch_projet_source \
    $DEPLOY_BASE_DIR \
    $DEPLOY_REPO \
    $DEPLOY_BRANCH
build_db_migrations \
    'PizziDeploy' \
    pizzi-db-migration
