FROM node:lts AS build

COPY webhooker /build

RUN cd /build \
    && chmod 755 webhooker.sbin webhooker.console \
    && mv config.docker.js config.js \
    && npm install --production && npm cache clean --force;

FROM node:lts

RUN mkdir -p /app/logs /app/webhooker

COPY --from=build /build /app/webhooker

WORKDIR /app/webhooker

CMD ["/app/webhooker/webhooker.sbin"]