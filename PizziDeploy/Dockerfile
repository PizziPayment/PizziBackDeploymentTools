FROM node:12-alpine

WORKDIR /usr/opt/PizziMigration

VOLUME /etc/PizziMigration

COPY sources/src ./src/
COPY sources/.pnp.cjs .
COPY sources/.yarn/cache .yarn/cache/

ENTRYPOINT ["node", "-r", "./.pnp.cjs", "src/main.js", "table", "alter", "-c", "/etc/PizziMigration/config.json"]
