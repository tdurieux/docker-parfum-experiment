# Note: this only supports the NextJS web server, not the Netlify lambdas
FROM node:12.16.3

COPY . /app
WORKDIR /app

# Install git because we need it to pull tinlake-pool-config when running npm install
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN npm install && npm cache clean --force;

RUN npm run build:next

EXPOSE 3000

# Run container as non-root (unprivileged) user
USER node

ENTRYPOINT ["sh", "docker/start.sh"]