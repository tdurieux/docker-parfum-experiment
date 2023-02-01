## Custom Dockerfile
FROM ubuntu@sha256:45c6f8f1b2fe15adaa72305616d69a6cd641169bc8b16886756919e7c01fa48b
COPY ./qemu-x86_64-static /usr/bin/

## Install a gedit
USER 0

RUN apt update \
&& apt install --no-install-recommends -y gcc \
&& apt install --no-install-recommends -y build-essential \
&& apt install --no-install-recommends -y gcc-arm-none-eabi && rm -rf /var/lib/apt/lists/*;

## switch back to default user
USER 1000
