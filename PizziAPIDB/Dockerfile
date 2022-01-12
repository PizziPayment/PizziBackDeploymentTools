FROM node:12-alpine

WORKDIR /usr/opt/PizziMigration

VOLUME /etc/PizziMigration

COPY sources/deploy-db/src ./src/
COPY sources/deploy-db/.pnp.cjs .
COPY sources/deploy-db/.yarn/cache .yarn/cache/

ENTRYPOINT ["node", "-r", "./.pnp.cjs", "src/main.js", "table", "alter", "-c", "/etc/PizziMigration/config.json"]
