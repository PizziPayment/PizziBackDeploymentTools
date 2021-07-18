#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=pizzi-auth-runner

(cd runner && docker build . -t $IMAGE_TAG)
