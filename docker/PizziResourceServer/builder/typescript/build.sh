#!/usr/bin/env bash
set -euo pipefail

NPM_CACHE=/npm-cache

npm set cache $NPM_CACHE

cd /sources

echo "Resource server: Compile typescript"
npm install
npm run build

echo "Copy artefacts"
cp -r ./dist /artefacts
