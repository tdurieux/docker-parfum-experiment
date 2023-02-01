FROM node:10-buster-slim AS build

WORKDIR /build
ADD . /build

RUN apt update && apt install --no-install-recommends --yes git binutils && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
RUN npm run build

FROM alpine:latest

RUN apk add --update --no-cache lighttpd

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=build /build/dist /app
COPY --from=build /build/assets/docker_init /app/start

EXPOSE 80

ENTRYPOINT ["lighttpd", "-D"]
CMD ["-f", "/etc/lighttpd/lighttpd.conf"]
