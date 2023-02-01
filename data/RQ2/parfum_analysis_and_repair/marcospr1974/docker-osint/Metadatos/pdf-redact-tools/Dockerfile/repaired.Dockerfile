FROM ubuntu:latest

RUN apt-get update \
    && apt-get install --no-install-recommends software-properties-common -y \
    && add-apt-repository ppa:micahflee/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends pdf-redact-tools -y \
    && apt-get clean \
    && mkdir /output && rm -rf /var/lib/apt/lists/*;

VOLUME [ "/output" ]

ENTRYPOINT ["pdf-redact-tools"]
CMD ["-h"]
