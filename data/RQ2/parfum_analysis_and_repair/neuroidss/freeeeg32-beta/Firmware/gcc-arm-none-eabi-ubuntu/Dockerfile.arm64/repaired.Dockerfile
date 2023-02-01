FROM ubuntu@sha256:01a2038b20d165ab7df81934f9849bdfbc59bd6f6322c5d11e341504f66ec266
COPY ./qemu-aarch64-static /usr/bin/

USER 0

RUN apt update \
&& apt install --no-install-recommends -y gcc \
&& apt install --no-install-recommends -y build-essential \
&& apt install --no-install-recommends -y gcc-arm-none-eabi && rm -rf /var/lib/apt/lists/*;

USER 1000
