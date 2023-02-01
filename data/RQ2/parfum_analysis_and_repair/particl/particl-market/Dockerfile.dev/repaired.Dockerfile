# --------------- STAGE 1: Develop ---------------
FROM ludx/dev:12 as stage-develop

# Install dev dependencies
RUN apk update
# libc6-compat linux-headers autoconf git wget curl bash make nasm build-base openssl-dev ca-certificates libssl1.1 openssl \
#    && rm -rf /var/cache/apk/* \

CMD ["npm", "run", "dev"]

# --------------- STAGE 2: Build ---------------
FROM stage-develop as stage-build

# Install dependencies first so that cache layer isn't invalidated by source code change
#COPY package*.json yarn.lock ./
#COPY common ./common
RUN yarn install && yarn cache clean;

#COPY . ./
#RUN npm run lint \
#    && yarn start test \
#    && yarn start test.integration \
#    && yarn start test.e2e \
#    && npm run build

# --------------- STAGE 3: Host ---------------
FROM ludx/base:12

RUN mkdir -p /usr/src/app/data/database && rm -rf /usr/src/app/data/database
WORKDIR /usr/src/app

COPY --from=stage-build /app .

#USER node
#CMD ["yarn", "start", "serve"]

# EXPOSE 3000 3100 3200
