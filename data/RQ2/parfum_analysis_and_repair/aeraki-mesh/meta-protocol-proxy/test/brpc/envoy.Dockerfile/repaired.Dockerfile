FROM ubuntu:18.04

RUN apt update -y \
    && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ADD . /usr/local/bin

CMD /usr/local/bin/envoy -c /usr/local/bin/test.yaml -l debug