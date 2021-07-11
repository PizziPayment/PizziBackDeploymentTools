#!/usr/bin/env bash

IMAGE_TAG=pizzi-auth-runner

(cd runner && docker build . -t $IMAGE_TAG)
