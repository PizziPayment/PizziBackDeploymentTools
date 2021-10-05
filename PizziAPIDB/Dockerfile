FROM node:12-alpine

WORKDIR /usr/opt/PizziMigration

VOLUME /etc/PizziMigration

COPY sources/deploy/src ./src/
COPY sources/deploy/node_modules ./node_modules/

ENTRYPOINT ["node", "src/main.js", "table", "alter", "-c", "/etc/PizziMigration/config.json"]
