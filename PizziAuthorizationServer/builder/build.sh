#!/usr/bin/env bash
set -euo pipefail

yarn config set registry $REGISTY_URL/
yarn config set cache-folder $NPM_CACHE

echo "Authorization server: Fetch dependencies"
yarn install
echo "Authorization server: Compile typescript"
yarn run build

echo "Copy artefacts"
cp -r ./dist /artefacts

chown $ARTEFACTS_UID:$ARTEFACTS_GID -R /artefacts
