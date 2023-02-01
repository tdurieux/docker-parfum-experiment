FROM dockercore/golang-cross

RUN apt-get update && \
    apt-get install --no-install-recommends -y bash \
                       build-essential \
                       curl \
                       docker \
                       git \
                       mercurial \
                       rpm && rm -rf /var/lib/apt/lists/*;

RUN curl -sfL https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh

ENTRYPOINT ["goreleaser"]
