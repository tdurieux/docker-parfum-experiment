FROM python:3.7.1-stretch

WORKDIR /trezor-emulator

COPY ./ /trezor-emulator
RUN make vendor

RUN apt-get update && apt-get install -y --no-install-recommends libusb-1.0-0 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir scons trezor
RUN make build_unix_noui

ENTRYPOINT ["emulator/run.sh"]
EXPOSE 21324/udp 21325
