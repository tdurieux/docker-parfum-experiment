#-----------------BUILDER-----------------
#-----------------------------------------
FROM node:16-alpine3.15 AS builder
RUN apk add --no-cache --update-cache --repository https://alpine.global.ssl.fastly.net/alpine/v3.15/community/ \
  python3 build-base sqlite-dev sqlite-libs vips-dev fftw-dev gcc g++ make libc6-compat && ln -snf / && ln -snf /usr/bin/python3 /usr/bin/python
COPY pigallery2-release /app
WORKDIR /app
RUN npm install --unsafe-perm && npm cache clean --force;
RUN mkdir -p /app/data/config && \
    mkdir -p /app/data/db && \
    mkdir -p /app/data/images && \
    mkdir -p /app/data/tmp


#-----------------MAIN--------------------
#-----------------------------------------
FROM node:16-alpine3.15 AS main
WORKDIR /app
ENV NODE_ENV=production \
    # overrides only the default value of the settings (the actualy value can be overwritten through config.json)
    default-Server-Database-dbFolder=/app/data/db \
    default-Server-Media-folder=/app/data/images \
    default-Server-Media-tempFolder=/app/data/tmp \
    # flagging dockerized environemnt
    PI_DOCKER=true

EXPOSE 80
RUN apk add --no-cache --update-cache --repository https://alpine.global.ssl.fastly.net/alpine/v3.15/community/ \
    vips ffmpeg
COPY --from=builder /app /app
VOLUME ["/app/data/config", "/app/data/db", "/app/data/images", "/app/data/tmp"]
HEALTHCHECK --interval=40s --timeout=30s --retries=3 --start-period=60s \
  CMD wget --quiet --tries=1 --no-check-certificate --spider \
  http://localhost:80/heartbeat || exit 1

# after a extensive job (like video converting), pigallery calls gc, to clean up everthing as fast as possible
# Exec form entrypoint is need otherwise (using shell form) ENV variables are not properly passed down to the app
ENTRYPOINT ["node", "./src/backend/index", "--expose-gc",  "--config-path=/app/data/config/config.json"]

