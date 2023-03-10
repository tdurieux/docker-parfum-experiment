FROM alpine:3.11 AS qemu
RUN apk --update add --no-cache curl
RUN cd /tmp && \
    curl -f -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz | tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static .

FROM arm32v6/node:12-alpine AS prod
COPY --from=qemu /tmp/qemu-arm-static /usr/bin/
RUN apk add --no-cache --update build-base python2 git
WORKDIR /usr/src/app
# Add package.json
COPY package*.json .
# Restore node modules
RUN npm install --production && npm cache clean --force;

## BUILD STEP
FROM prod AS build
# Add everything else not excluded by .dockerignore
COPY . .
# Build it
RUN npm install && \
    npm run build-prod && npm cache clean --force;

## FINAL STEP
FROM prod as final
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.name="Landroid Bridge" \
        org.label-schema.description="Bridge for connecting the Worx Landroid S Lawn Mower to home automation systems like OpenHAB or FHEM." \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-url="https://github.com/virtualzone/landroid-bridge" \
        org.label-schema.schema-version="1.0"
COPY --from=build /usr/src/app/dist ./dist
COPY www/ ./www/
EXPOSE 3000
CMD [ "node", "dist/server.js" ]
