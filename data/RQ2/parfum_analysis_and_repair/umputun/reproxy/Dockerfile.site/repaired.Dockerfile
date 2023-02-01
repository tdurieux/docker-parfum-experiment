FROM --platform=$BUILDPLATFORM node:16-alpine as build

WORKDIR /build
COPY site/ /build
COPY README.md /build/src/index.md

RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN	ls -la /build/public

FROM ghcr.io/umputun/reproxy
COPY --from=build /build/public /srv/site
EXPOSE 8080
USER app
ENTRYPOINT ["/srv/reproxy", "--assets.location=/srv/site"]
