#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=pizzi-rsc-runner

(cd runner && docker build . -t $IMAGE_TAG)
