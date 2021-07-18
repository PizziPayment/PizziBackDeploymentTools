# Pizzi API Common

## Deployment tools

Deployment tools can be found in the `docker` folder.

The `update.sh` script builds the runner images of the authorization and
resource servers. To build those images, the script pulls the repositories and
make two `builder` images.

The `clean.sh` script cleans artefacts and fetched packages needed by the build
step.

Once you ran `update.sh`, you can launch the services of the
`docker-compose.yaml` in the following order:
- db
- rsc-server auth-server

A `.env` file contains all the environment variables to set with default
values. Tweak them as you wish.
