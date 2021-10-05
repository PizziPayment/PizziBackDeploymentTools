#!/usr/bin/env bash
set -euo pipefail

AUTH_SERVER=PizziAuthorizationServer
RSC_SERVER=PizziResourceServer
DB=PizziAPIDB

########################
# Delete artefacts of a project.
# Globals:
#   None
# Arguments:
#   project_dir: path of the project directory
#   artefact_location: artefacts path in the project_dir
#   artefacts: an array of artefacts(file/folder) to delete
########################
delete_artefacts() {
    local project=$1; shift
    local artefact_location=$1; shift
    local artefacts=("$@")
    for artefact in ${artefacts[@]}; do
        artefact=$project/$artefact_location/$artefact

        if [[ -e $artefact ]]; then
            rm -rf $artefact
        fi
    done
}

AUTH_SERVER_ARTEFACTS=("dist" "node_modules")
delete_artefacts $AUTH_SERVER "runner/artefacts" "${AUTH_SERVER_ARTEFACTS[@]}"
RSC_SERVER_ARTEFACTS=("dist" "node_modules")
delete_artefacts $RSC_SERVER "runner/artefacts" "${RSC_SERVER_ARTEFACTS[@]}"
DB_ARTEFACTS=("node_modules")
delete_artefacts $DB "source/deploy/node_modules" "${DB_ARTEFACTS[@]}"

rm -rf \
    $AUTH_SERVER/builder/sources \
    $RSC_SERVER/builder/sources \
    $DB/sources

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
