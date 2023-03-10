FROM busybox

COPY .yarnrc package.json yarn.lock ./scripts/workspace-util.js /build/
COPY ./npm-packages-offline-cache  /build/npm-packages-offline-cache
COPY ./packages  ./packages-with-source

COPY ./packagejsons /build