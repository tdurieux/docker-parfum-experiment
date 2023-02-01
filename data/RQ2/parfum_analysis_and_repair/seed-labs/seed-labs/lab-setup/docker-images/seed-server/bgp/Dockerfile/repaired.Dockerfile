FROM handsonsecurity/seed-ubuntu:small
ARG DEBIAN_FRONTEND=noninteractive

# Instrall the Bird server (for BGP)
RUN apt-get update && apt-get -y --no-install-recommends install bird && rm -rf /var/lib/apt/lists/*;

CMD mkdir -p /run/bird &&  bird -d

