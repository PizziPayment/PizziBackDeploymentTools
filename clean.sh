#!/usr/bin/env bash
set -euo pipefail

AUTH_SERVER=PizziAuthorizationServer
RSC_SERVER=PizziResourceServer
DB=PizziDeploy

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

AUTH_SERVER_ARTEFACTS=("dist" ".yarn/cache" ".pnp.cjs" "config/custom-environment-variables.json" "config/default.json")
delete_artefacts $AUTH_SERVER "runner/artefacts" "${AUTH_SERVER_ARTEFACTS[@]}"
RSC_SERVER_ARTEFACTS=("dist" ".yarn/cache" ".pnp.cjs" "config/custom-environment-variables.json" "config/default.json")
delete_artefacts $RSC_SERVER "runner/artefacts" "${RSC_SERVER_ARTEFACTS[@]}"

rm -rf \
    $AUTH_SERVER/sources \
    $RSC_SERVER/sources \
    $DB/sources \
    .yarn

docker_images=(
    "pizzi-auth-runner"
    "pizzi-rsc-runner"
    "pizzi-db-migration"
)
for image in ${docker_images[@]}; do
    if [[ ! -z $(docker image ls $image -q) ]]; then
        docker image rm -f $image
    fi
done
