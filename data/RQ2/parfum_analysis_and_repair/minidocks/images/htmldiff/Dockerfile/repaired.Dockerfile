FROM minidocks/node
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN npm -g install node-htmldiff && clean && npm cache clean --force;

COPY rootfs /

CMD [ "htmldiff" ]

