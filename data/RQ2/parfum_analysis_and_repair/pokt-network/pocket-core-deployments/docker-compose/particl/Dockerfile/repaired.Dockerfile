FROM ubuntu
LABEL maintainer="lowell@pokt.network"
RUN useradd -d /home/particl_user -m -s /bin/bash particl_user
USER root
WORKDIR /home/particl
RUN apt-get update && apt-get install --no-install-recommends -y wget && wget https://github.com/particl/particl-core/releases/download/v0.18.1.6/particl-0.18.1.6-x86_64-linux-gnu.tar.gz && tar -xvf particl-0.18.1.6-x86_64-linux-gnu.tar.gz && rm particl-0.18.1.6-x86_64-linux-gnu.tar.gz && rm -rf /var/lib/apt/lists/*;
USER particl_user
WORKDIR particl-0.18.1.6/bin
ENTRYPOINT ["./particld"]
