ARG LAGOON_GIT_BRANCH
ARG IMAGE_REPO
# STAGE 1: Loading Image lagoon-node-packages-builder which contains node packages shared by all Node Services
FROM ${IMAGE_REPO:-amazeeiolagoon}/yarn-workspace-builder:${LAGOON_GIT_BRANCH:-latest} as yarn-workspace-builder

# STAGE 2: specific service Image
FROM ${IMAGE_REPO:-amazeeiolagoon}/node:8

# Copying generated node_modules from the first stage
COPY --from=yarn-workspace-builder /app /app

# Setting the workdir to the service, all following commands will run from here
WORKDIR /app/services/api/

# Copying the .env.defaults into the Workdir, as the dotenv system searches within the workdir for it
COPY --from=yarn-workspace-builder /app/.env.defaults .

# Copying files from our service
COPY . .

# Verify that all dependencies have been installed via the yarn-workspace-builder
RUN yarn check --verify-tree

# Making sure we run in production
ENV NODE_ENV=production \
    LOGSDB_ADMIN_PASSWORD=admin \
    KEYCLOAK_ADMIN_PASSWORD=admin

# The API is not very resilient to sudden mariadb restarts which can happen when the api and mariadb are starting
# at the same time. So we have a small entrypoint which waits for mariadb to be fully ready.
COPY wait-for-mariadb.sh /lagoon/entrypoints/99-wait-for-mariadb.sh

CMD ["yarn", "start"]