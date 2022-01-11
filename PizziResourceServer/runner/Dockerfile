FROM node:12-alpine

COPY ./artefacts /usr/opt/PizziRsc

WORKDIR /usr/opt/PizziRsc

EXPOSE 3000

ENTRYPOINT ["node", "-r", "./.pnp.cjs", "dist/index.js"]
