# BUILD IMAGE
FROM node:16.14-alpine
RUN apk add --no-cache git
WORKDIR /opt/sisyfos-audio-controller
COPY . .
RUN yarn --check-files --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN yarn --check-files --frozen-lockfile --production --force && yarn cache clean;
RUN yarn cache clean && yarn cache clean;

# DEPLOY IMAGE
FROM node:16.14-alpine
WORKDIR /opt/sisyfos-audio-controller
COPY --from=0 /opt/sisyfos-audio-controller .
EXPOSE 1176/tcp
EXPOSE 1176/udp
EXPOSE 5255/tcp
EXPOSE 5255/udp
CMD ["yarn", "start"]
