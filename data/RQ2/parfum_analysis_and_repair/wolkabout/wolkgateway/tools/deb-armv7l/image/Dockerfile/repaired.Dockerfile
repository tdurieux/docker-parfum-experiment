FROM arm32v7/debian:buster

WORKDIR /root

RUN apt update && apt install --no-install-recommends -y libglib2.0-0 libsqlite3-0 libssl1.1 && rm -rf /var/lib/apt/lists/*;

COPY *.deb /root
RUN dpkg -i *.deb
RUN rm *.deb

CMD ["WolkGatewayApp", "/etc/wolkGateway/gatewayConfiguration.json", "INFO"]
