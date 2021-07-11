#!/usr/bin/env bash

IMAGE_TAG=pizzi-rsc-runner

(cd runner && docker build . -t $IMAGE_TAG)
