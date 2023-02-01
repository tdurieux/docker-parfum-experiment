FROM debian:latest

RUN apt-get update && apt-get -y --no-install-recommends install systemd procps && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/

COPY netclient .

CMD ["./netclient checkin"]
