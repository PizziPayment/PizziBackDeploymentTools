# Pizzi Back Deployment Tools

## Scripts:
- `update.sh`: builds the runner images of the authorization and resource
  servers.
  - Requirements:
    - git
    - npm
    - docker
  - Steps:
    - Fetch project from github
    - Fetch production project dependencies with npm
    - Compile typescript in a container
    - Build a runner from the produced artefacts

- `clean.sh`: cleans artefacts produced by the `update.sh` and removes created
  docker volume and images.

Once you've run `update.sh`, `docker-compose.yaml`'s services can be launched
in the following order:
- db
- rsc-server auth-server

A `.env` file contains all the environment variables to set with default
values. Tweak them as you wish.
