FROM node:12-alpine

COPY ./artefacts /usr/opt/PizziAuth

WORKDIR /usr/opt/PizziAuth

EXPOSE 3000

ENTRYPOINT ["node", "-r", "./.pnp.cjs", "dist/index.js"]
