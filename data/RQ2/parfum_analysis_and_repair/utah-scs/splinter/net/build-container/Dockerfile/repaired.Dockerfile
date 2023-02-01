FROM ubuntu:artful
MAINTAINER "Aurojit Panda <apanda@cs.berkeley.edu>"
RUN apt-get -yq update && apt-get -yq --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq update && apt-get -yq --no-install-recommends install build-essential \
				vim-nox curl \
				pciutils sudo git \
				python python3 gosu && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq update && apt-get -yq --no-install-recommends install libssl-dev \
					libgnutls30 libgnutls-openssl-dev \
					libcurl4-gnutls-dev cmake bash libpcap-dev libnuma-dev \
					tcpdump clang-5.0 && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p ~/.ssh && ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
ENV PATH /root/.cargo/bin:$PATH
RUN cargo install rustfmt
CMD [/bin/bash]
