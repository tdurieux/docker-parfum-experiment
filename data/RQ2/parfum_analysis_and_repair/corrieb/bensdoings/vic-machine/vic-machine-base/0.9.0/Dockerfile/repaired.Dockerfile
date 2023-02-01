FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y jq ca-certificates curl tar | bc && rm -rf /var/lib/apt/lists/*;

RUN mkdir /vic \
    && curl -f -L https://bintray.com/vmware/vic/download_file?file_path=vic_0.9.0.tar.gz | tar xz -C /vic \
    && cp /vic/vic/vic-machine-linux /vic \
    && cp /vic/vic/*.iso /vic \
    && rm -fr /vic/vic

CMD ["/bin/bash"]
