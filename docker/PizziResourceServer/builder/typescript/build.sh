#!/usr/bin/env bash

NPM_CACHE=/npm-cache

# Stop script when something fails
set -euo pipefail

npm set cache $NPM_CACHE

cd /sources

echo "Resource server: Compile typescript"
npm install
npm run build

echo "Copy artefacts"
cp -r ./dist /artefacts
