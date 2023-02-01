FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;

COPY /kiosk-linux-* /app/kiosk
COPY /migration /app/migration

VOLUME /app/configs

WORKDIR /app

EXPOSE 8080

ENTRYPOINT ["./kiosk"]
