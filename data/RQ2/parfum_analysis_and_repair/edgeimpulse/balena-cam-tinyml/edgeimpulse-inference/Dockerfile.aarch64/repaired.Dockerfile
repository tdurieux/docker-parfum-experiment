# Pinning to armv7hf so libvips compiles
FROM balenalib/armv7hf-node:build

# Install dependencies
RUN apt-get update && \
  apt-get install --no-install-recommends -yq unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose websocket port
EXPOSE 8080

# Switch to working directory for our app
WORKDIR /usr/src/app

# Copies the package.json first for better cache on later pushes
COPY ./app/package.json /usr/src/app/

# Install dependencies
RUN JOBS=MAX npm install --production && rm -rf /tmp/* && npm cache clean --force;

# Copy all the source code in.
COPY ./app/ /usr/src/app/

# Launch our binary on container startup.
CMD ["npm", "start"]