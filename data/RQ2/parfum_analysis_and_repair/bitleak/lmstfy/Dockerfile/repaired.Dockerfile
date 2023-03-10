FROM golang:1.15.6

WORKDIR /lmstfy
ADD ./ /lmstfy
RUN apt update -y && apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
RUN cd /lmstfy && make
EXPOSE 7777:7777
ENTRYPOINT ["/lmstfy/_build/lmstfy-server", "-c", "/lmstfy/config/docker-image-conf.toml"]

