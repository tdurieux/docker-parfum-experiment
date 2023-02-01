FROM debian:jessie AS jessie

RUN apt update
RUN apt install --no-install-recommends -y apt-utils apt-transport-https ca-certificates debian-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gcc build-essential libelf-dev; rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-compiler-gcc* || true && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-kbuild*; rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y -f \
linux-headers-4.9.0-0.bpo.12-all-amd64 \
linux-headers-4.9.0-0.bpo.11-all-amd64 \
linux-headers-4.9-amd64 \
linux-headers-3.16.0-6-all-amd64 \
linux-headers-3.16.0-11-amd64 \
linux-headers-amd64 || true && rm -rf /var/lib/apt/lists/*;



ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh