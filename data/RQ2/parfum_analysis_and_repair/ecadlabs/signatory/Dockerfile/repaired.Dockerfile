FROM ubuntu:22.04
RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

COPY ./signatory /bin
COPY ./signatory-cli /bin

ENTRYPOINT ["/bin/signatory"]

