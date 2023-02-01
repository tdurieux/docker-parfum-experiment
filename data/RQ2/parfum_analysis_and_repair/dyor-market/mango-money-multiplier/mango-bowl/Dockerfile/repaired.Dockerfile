from node:16-slim
# version arg contains current git tag
ARG VERSION_ARG
# install git
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# install mango-bowl globally (exposes mango-bowl command)
RUN npm install --global --unsafe-perm mango-bowl@$VERSION_ARG && npm cache clean --force;
# run it
CMD mango-bowl