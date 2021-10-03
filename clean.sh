#!/usr/bin/env bash
set -euo pipefail

AUTH_SERVER=PizziAuthorizationServer
RSC_SERVER=PizziResourceServer

delete_artefacts() {
    local project=$1; shift
    local artefacts=("$@")
    for artefact in ${artefacts[@]}; do
        artefact=$project/runner/artefacts/$artefact

        if [[ -e $artefact ]]; then
            rm -rf $artefact
        fi
    done
}

AUTH_SERVER_ARTEFACTS=("dist" "node_modules")
delete_artefacts $AUTH_SERVER "${AUTH_SERVER_ARTEFACTS[@]}"
RSC_SERVER_ARTEFACTS=("dist" "node_modules")
delete_artefacts $RSC_SERVER "${RSC_SERVER_ARTEFACTS[@]}"

rm -rf \
    $AUTH_SERVER/builder/sources \
    $RSC_SERVER/builder/sources

docker_volumes=(
    "pizzi-npm-cache"
)
for volume in ${docker_volumes[@]}; do
    if [[ ! -z $(docker volume ls -f name=$volume -q) ]]; then
        docker volume rm $volume
    fi
done

docker_images=(
    "pizzi-auth_builder"
    "pizzi-auth_runner"
    "pizzi-rsc_builder"
    "pizzi-rsc_runner"
)
for image in ${docker_images[@]}; do
    if [[ ! -z $(docker image ls $volume -q) ]]; then
        docker image rm -f $image
    fi
done
