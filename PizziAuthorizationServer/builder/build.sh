#!/usr/bin/env bash
set -euo pipefail

npm set cache $NPM_CACHE

echo "Authorization server: Compile typescript"
npm install
npm run build

echo "Copy artefacts"
cp -r ./dist /artefacts

chown $ARTEFACTS_UID:$ARTEFACTS_GID -R /artefacts
