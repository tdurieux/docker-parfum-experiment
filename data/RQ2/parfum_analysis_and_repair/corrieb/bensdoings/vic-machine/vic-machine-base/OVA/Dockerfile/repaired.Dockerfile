FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y jq ca-certificates curl tar bc && rm -rf /var/lib/apt/lists/*;

RUN mkdir /vic \
    && curl -f -k -L https://10.118.69.29:9443/vic_1.1.1.tar.gz | tar xz -C /vic \
    && cp /vic/vic/vic-machine-linux /vic \
    && cp /vic/vic/*.iso /vic \
    && rm -fr /vic/vic

CMD ["/bin/bash"]
