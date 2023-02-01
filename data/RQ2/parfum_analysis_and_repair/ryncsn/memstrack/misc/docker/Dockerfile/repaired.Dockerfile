ARG BASE_IMAGE

FROM ${BASE_IMAGE:-ubuntu}

RUN apt-get update && apt-get install --no-install-recommends -y gcc make sudo libncurses-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /mnt
