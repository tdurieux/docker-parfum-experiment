## Custom Dockerfile
FROM ubuntu@sha256:e80b8affb2361dc632c1fa8fcbf6b6514f750eb6ef99b7e7f825a55f849bfd89
COPY ./qemu-arm-static /usr/bin/

## Install a gedit
USER 0

RUN apt update \
&& apt install --no-install-recommends -y gcc \
&& apt install --no-install-recommends -y build-essential \
&& apt install --no-install-recommends -y gcc-arm-none-eabi && rm -rf /var/lib/apt/lists/*;

## switch back to default user
USER 1000
