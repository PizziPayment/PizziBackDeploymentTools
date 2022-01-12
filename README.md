# Pizzi Back Deployment Tools

## Scripts:
- `update.sh`: builds images of the resource server runner, the authorization
  server runner and the database migration tool.
  - Requirements:
    - git
    - yarn
    - docker
  - Steps:
    - Fetch project from github
    - For runners:
        - Fetch production project dependencies with yarn (artefact: `.yarn/cache`)
        - Compile typescript (artefact: `dist`)
        - Build a runner from the produced artefacts
    - For the db migration:
        - Fetch dependencies with yarn (artefact: `node_modules`)
        - Build an image from the artefact and the application code.


- `clean.sh`: cleans artefacts produced by the `update.sh` and removes created
  docker images.

Once you've run `update.sh`, `docker-compose.yaml`'s services can be launched
in the following order:
- db
- db-migration
- rsc-server auth-server
```bash
docker compose up -d db
sleep 3 # Let the database inits itself.
docker compose run --rm db-migration
docker compose up -d auth-server rsc-server
```

For now the `db-migration` image isn't configurable via an env file. As a
substitution, a config file (`PizziAPIDB/config.json`) is mounted in the
container so you can changed the configuration without rebuilding the image.

### .env files

A `.env` file with default value is available at the root of the repository for
services in the compose file.
