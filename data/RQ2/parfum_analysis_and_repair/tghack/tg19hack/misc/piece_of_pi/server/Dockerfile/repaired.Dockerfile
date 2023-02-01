FROM ubuntu:bionic

RUN apt update && apt install --no-install-recommends -y socat python-minimal && rm -rf /var/lib/apt/lists/*;
RUN useradd -m tghack
COPY qemu-system-arm /home/tghack/
COPY run.py /home/tghack
COPY start_server.sh /home/tghack

# just to have all the libs...
RUN apt install --no-install-recommends -y qemu-system-arm && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "/home/tghack/start_server.sh" ]
