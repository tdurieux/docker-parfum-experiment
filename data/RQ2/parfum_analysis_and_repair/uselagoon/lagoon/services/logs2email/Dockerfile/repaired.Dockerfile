ARG LAGOON_GIT_BRANCH
ARG IMAGE_REPO
ARG UPSTREAM_REPO
ARG UPSTREAM_TAG
# STAGE 1: Loading Image lagoon-node-packages-builder which contains node packages shared by all Node Services
FROM ${IMAGE_REPO:-lagoon}/yarn-workspace-builder as yarn-workspace-builder

# STAGE 2: specific service Image
FROM ${UPSTREAM_REPO:-uselagoon}/node-16:${UPSTREAM_TAG:-latest}

ARG LAGOON_VERSION
ENV LAGOON_VERSION=$LAGOON_VERSION

COPY entrypoints/50-ssmtp.sh /lagoon/entrypoints/
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN apk add --no-cache ssmtp

RUN fix-permissions /etc/ssmtp/ssmtp.conf \
   && fix-permissions /usr/sbin/ssmtp

# Copying generated node_modules from the first stage
COPY --from=yarn-workspace-builder /app /app

# Setting the workdir to the service, all following commands will run from here
WORKDIR /app/services/logs2email/

# Copying the .env.defaults into the Workdir, as the dotenv system searches within the workdir for it
COPY --from=yarn-workspace-builder /app/.env.defaults .

# Copying files from our service
COPY . .

# Verify that all dependencies have been installed via the yarn-workspace-builder
RUN yarn check --verify-tree && yarn cache clean;

# Making sure we run in production
ENV NODE_ENV production

RUN yarn build

CMD ["yarn", "start"]
