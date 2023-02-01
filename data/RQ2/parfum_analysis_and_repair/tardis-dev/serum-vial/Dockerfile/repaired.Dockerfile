from node:16-slim
# version arg contains current git tag
ARG VERSION_ARG
# install git
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# install serum-vial globally (exposes serum-vial command)
RUN npm install --global --unsafe-perm serum-vial@$VERSION_ARG && npm cache clean --force;
# run it
CMD serum-vial