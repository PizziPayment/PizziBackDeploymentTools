#!/usr/bin/env bash
set -euo pipefail

NPM_CACHE=/npm-cache

npm set cache $NPM_CACHE

cd /sources

echo "Authorization server: Fetch npm packages"
npm install --production

echo "Copy artefacts"
cp -r ./node_modules /artefacts
