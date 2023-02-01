FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y jq ca-certificates curl tar bc && rm -rf /var/lib/apt/lists/*;

RUN mkdir /vic \
    && curl -f -L https://storage.googleapis.com/vic-engine-releases/vic_v1.3.1.tar.gz | tar xz -C /vic \
    && cp /vic/vic/vic-machine-linux /vic \
    && cp /vic/vic/*.iso /vic \
    && rm -fr /vic/vic

CMD ["/bin/bash"]
