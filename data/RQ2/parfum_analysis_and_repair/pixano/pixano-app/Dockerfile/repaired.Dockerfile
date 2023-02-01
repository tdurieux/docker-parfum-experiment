FROM ubuntu:20.04

# Install Node.js
RUN apt-get update && apt-get install --no-install-recommends -y --reinstall ca-certificates curl build-essential && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN node --version
RUN npm install -g npm@6.10.0 && npm cache clean --force;

# Copy files for the frontend
COPY frontend frontend

# Copy files for the backend
COPY package.json package.json
COPY server server
COPY cli cli

# Build frontend and install backend dependencies
RUN npm run deps && npm run build && rm -rf frontend

EXPOSE 3000

# default files and folders (usefull when no volume can be mounted with this image)
RUN mkdir -p /data
COPY data-test /data/data-test

# ENTRYPOINT ["node", "server/server.js"]
RUN echo 'node cli/pixano "$@"' > entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh" ]
CMD []
