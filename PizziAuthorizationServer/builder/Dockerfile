FROM node:16

WORKDIR /sources

VOLUME /artefacts

# Volume to cache dependencies
VOLUME /npm-cache

COPY ./build.sh ./sources/package.json ./sources/yarn.lock ./sources/.npmrc ./sources/tsconfig.json ./
COPY ./sources/app ./app

ENTRYPOINT ["./build.sh"]
