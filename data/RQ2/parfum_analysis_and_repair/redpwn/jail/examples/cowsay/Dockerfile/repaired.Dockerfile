FROM ubuntu AS app
RUN apt-get update && apt-get install --no-install-recommends -y cowsay && rm -rf /var/lib/apt/lists/*

FROM pwn.red/jail
COPY --from=app / /srv
COPY cowsay.sh /srv/app/run
