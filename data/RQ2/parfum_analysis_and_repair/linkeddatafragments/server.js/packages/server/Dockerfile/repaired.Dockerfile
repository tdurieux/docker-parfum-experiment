FROM node:16-slim

# Install location
ENV dir /var/www/@ldf/server

# Copy the server files
COPY components ${dir}/components/
COPY config ${dir}/config/
COPY bin ${dir}/bin/
COPY package.json ${dir}

# Set the npm registry
ARG NPM_REGISTRY=https://registry.npmjs.org/
RUN npm config set @ldf:registry $NPM_REGISTRY

# Install the node module
RUN apt-get update && \
    apt-get install --no-install-recommends -y g++ make python && \
    cd ${dir} && npm install --only=production && \
    apt-get remove -y g++ make python && apt-get autoremove -y && \
    rm -rf /var/cache/apt/archives && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Expose the default port
EXPOSE 3000

# Run base binary
WORKDIR ${dir}
ENTRYPOINT ["node", "bin/ldf-server"]

# Default command
CMD ["--help"]
