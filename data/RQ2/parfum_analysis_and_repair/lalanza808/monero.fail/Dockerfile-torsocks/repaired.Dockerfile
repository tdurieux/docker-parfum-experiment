FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends tor -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /run/tor \
  && chown -R debian-tor:debian-tor /run/tor \
  && chmod 700 -R /run/tor

COPY conf/torrc /etc/tor/torrc

USER debian-tor

EXPOSE 9050

ENTRYPOINT ["tor"]
