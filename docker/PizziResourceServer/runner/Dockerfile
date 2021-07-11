FROM node:12-alpine

COPY ./artefacts /usr/opt/PizziRsc

WORKDIR /usr/opt/PizziRsc

EXPOSE 3000

ENTRYPOINT ["node", "dist/index.js"]
