FROM ubuntu:latest

COPY get-porter-cli.sh /scratch/

RUN apt-get update && apt-get install --no-install-recommends -y curl unzip git && rm -rf /var/lib/apt/lists/*;

ARG VERSION

RUN /scratch/get-porter-cli.sh

ENTRYPOINT ["porter"]
