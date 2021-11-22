#!/usr/bin/env bash
set -euo pipefail

NPM_CACHE=/npm-cache

yarn config set registry $REGISTY_URL/
yarn config set cache-folder $NPM_CACHE

echo "Resource server: Fetch dependencies"
yarn install
echo "Resource server: Compile typescript"
yarn run build

echo "Copy artefacts"
cp -r ./dist /artefacts

chown $ARTEFACTS_UID:$ARTEFACTS_GID -R /artefacts
