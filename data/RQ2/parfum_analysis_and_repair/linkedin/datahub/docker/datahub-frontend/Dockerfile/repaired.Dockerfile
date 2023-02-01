# Defining environment
ARG APP_ENV=prod

FROM alpine:3.14 AS base

RUN addgroup -S datahub && adduser -S datahub -G datahub

# Upgrade Alpine and base packages
RUN apk --no-cache --update-cache --available upgrade \
    && apk --no-cache add curl openjdk8-jre

FROM --platform=$BUILDPLATFORM node:16.13.0-alpine3.14 AS prod-build

# Upgrade Alpine and base packages
RUN apk --no-cache --update-cache --available upgrade \
    && apk --no-cache add perl openjdk8

ARG ENABLE_EMBER="false"
ARG USE_SYSTEM_NODE="true"
ENV CI=true
ENV GRADLE_OPTS="-Xms256m -Xmx512m"
COPY . datahub-src
RUN cd datahub-src \
    && ./gradlew :datahub-web-react:build -x test -x yarnTest -x yarnLint \
    && ./gradlew :datahub-frontend:dist -PenableEmber=${ENABLE_EMBER} -PuseSystemNode=${USE_SYSTEM_NODE} -x test -x yarnTest -x yarnLint \
    && cp datahub-frontend/build/distributions/datahub-frontend.zip ../datahub-frontend.zip \
    && cd .. && rm -rf datahub-src && unzip datahub-frontend.zip

FROM base as prod-install
COPY --from=prod-build /datahub-frontend /datahub-frontend/
RUN chown -R datahub:datahub /datahub-frontend && chmod 755 /datahub-frontend

FROM base as dev-install
# Dummy stage for development. Assumes code is built on your machine and mounted to this image.
# See this excellent thread https://github.com/docker/cli/issues/1134