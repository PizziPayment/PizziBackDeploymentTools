FROM node:16

# To avoid building a new image for each version of the app, sources are
# provided via a volume.
VOLUME /sources
VOLUME /artefacts
VOLUME /npm-cache

COPY build.sh .
ENTRYPOINT ["./build.sh"]
