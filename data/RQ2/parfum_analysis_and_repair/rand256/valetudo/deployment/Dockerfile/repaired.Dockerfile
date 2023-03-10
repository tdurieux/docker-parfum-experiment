FROM node:alpine

WORKDIR /deploy

# make sure you add the volume to the docker container /build to your host map
# SSH to your vacuum, stop the valetudo service (service valetudo stop), replace /usr/local/bin/valetudo with your new binary , chmod +x it and restart valetudo (service valetudo start).


RUN apk update \
; apk --no-cache add git bash ca-certificates \
; rm -rf /var/cache/apk/* \
; npm config set strict-ssl false \
; npm install -g n \
; npm cache clean --force; npm install -g pkg \
; mkdir "/deploy" \
; echo "#!/bin/sh" >> /deploy/build.sh \
; echo "git clone https://github.com/rand256/valetudo.git tmp && mv tmp/.git /deploy && rm -rf tmp && git reset --hard" >> /deploy/build.sh \
; echo "npm install" >> /deploy/build.sh \
; echo "npm run build" >> /deploy/build.sh \
; echo cp /deploy/valetudo /build >> /deploy/build.sh

ENTRYPOINT [ "sh", "/deploy/build.sh" ]
