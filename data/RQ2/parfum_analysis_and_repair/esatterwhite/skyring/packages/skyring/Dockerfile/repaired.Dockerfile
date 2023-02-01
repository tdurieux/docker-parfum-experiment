# 0001 BASE
FROM quay.io/esatterwhite/node:12 AS base
COPY ./package.json ./pnpm-lock.yaml /opt/app/
COPY . /opt/app
WORKDIR /opt/app
RUN pnpm install

# 0002 TEST
FROM quay.io/esatterwhite/node:12 AS test

RUN groupadd --gid 1000 skyring \
  && useradd --uid 1000 --gid skyring --shell /bin/bash --create-home skyring

RUN mkdir -p /var/data/skyring
RUN chown -R skyring:skyring /var/data/skyring
COPY --from=base --chown=skyring:skyring  /opt/app /opt/app

WORKDIR /opt/app
USER skyring

# 0003 PRUNE
FROM quay.io/esatterwhite/node:12 AS prune

COPY --from=base /opt/app /opt/app
WORKDIR /opt/app
RUN pnpm install --prod

# 0004 RELEASE