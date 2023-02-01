FROM debian:stretch-slim
EXPOSE 12345

RUN apt-get update && \
    apt-get install --no-install-recommends -yy libusb-1.0 && rm -rf /var/lib/apt/lists/*;

ADD https://developers.yubico.com/YubiHSM2/Releases/yubihsm2-sdk-1.0.1-debian9-amd64.tar.gz \
    /tmp/yubihsm-sdk.tar.gz

RUN tar xf /tmp/yubihsm-sdk.tar.gz -C /tmp && \
    dpkg -i /tmp/yubihsm2-sdk/yubihsm-connector_1.0.1-1_amd64.deb && rm /tmp/yubihsm-sdk.tar.gz

ENTRYPOINT ["yubihsm-connector", "-l", "0.0.0.0:12345", "-d"]
