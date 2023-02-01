FROM ubuntu:16.04

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
COPY ebrelayer ebrelayer
COPY ebcli_A ebcli_A
COPY boss4x boss4x
COPY evmxgoboss4x evmxgoboss4x
COPY sleep.sh sleep.sh

CMD ["/root/sleep.sh"]
