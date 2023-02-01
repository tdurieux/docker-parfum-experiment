ENTRYPOINT ["make"]

WORKDIR /utt

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash-completion \
    make && rm -rf /var/lib/apt/lists/*;

COPY . .
