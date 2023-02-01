FROM --platform=$BUILDPLATFORM node:16.13.1-bullseye as build
WORKDIR /usr/src/network
RUN npm config set \
	unsafe-perm=true \
	python="$(which python3)"
COPY . .
RUN --mount=type=cache,target=/root/.npm \
	npm run bootstrap-pkg --package=streamr-client && \
	npm run bootstrap-pkg --package=streamr-broker && \
	npm run prune-pkg -- streamr-broker

FROM --platform=$BUILDPLATFORM node:16.13.1-bullseye-slim
ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV:-production}
RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install \
	curl=7.74.0-1.3+deb11u1 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
RUN usermod -d /home/streamr -l streamr node && groupmod -n streamr node
USER streamr
WORKDIR /home/streamr/network
COPY --chown=root:root --from=build /usr/src/network/ .

ENV LOG_LEVEL=info

EXPOSE 1883/tcp
EXPOSE 7170/tcp
EXPOSE 7171/tcp

WORKDIR /home/streamr/network/packages/broker

# start broker from default config
CMD ["./bin/broker.js"]
