#!/usr/bin/env bash

NPM_CACHE=/npm-cache

# Stop script when something fails
set -euo pipefail

npm set cache $NPM_CACHE

cd /sources

echo "Authorization server: Fetch npm packages"
npm install --production

echo "Copy artefacts"
cp -r ./node_modules /artefacts
