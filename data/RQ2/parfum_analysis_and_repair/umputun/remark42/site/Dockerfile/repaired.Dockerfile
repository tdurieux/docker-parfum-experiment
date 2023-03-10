FROM node:16-alpine as build

WORKDIR /site
COPY ./ /site
RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN ls -la /site

FROM ghcr.io/umputun/reproxy
COPY --from=build /site/build /srv/site
EXPOSE 8080
USER app
ENTRYPOINT ["/srv/reproxy", "--assets.location=/srv/site"]
