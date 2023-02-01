from node:16-slim
# version arg contains current git tag
ARG VERSION_ARG
# install git
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
# install tardis-machine globally (exposes tardis-machine command)
RUN npm install --global --unsafe-perm tardis-machine@$VERSION_ARG && npm cache clean --force;
# run it
CMD tardis-machine --cache-dir=/.cache