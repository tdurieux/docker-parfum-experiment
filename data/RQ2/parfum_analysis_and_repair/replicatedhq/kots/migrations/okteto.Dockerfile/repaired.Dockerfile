FROM schemahero/schemahero:0.13.0-alpha.1 as schemahero

USER root
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
USER schemahero

WORKDIR /go/src/github.com/replicatedhq/kots/tables
COPY tables/ .