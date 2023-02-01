FROM minidocks/node
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

ARG svgo_version=2.8.0

RUN npm -g install svgo@$svgo_version && clean && npm cache clean --force;

COPY rootfs /

CMD [ "svgo" ]
