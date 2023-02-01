FROM nginmesh/ngx-rust-tool:1.21.0

MAINTAINER Sehyo Chang "sehyo@nginx.com"

RUN apt-get install --no-install-recommends -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src
ADD ./Makefile /src
ADD ./nginx.mk /src
RUN mkdir /src/build
RUN mkdir /src/protobuf
ADD ./protobuf /src/protobuf
ADD ./module /src/module
RUN cd /src;make nginx-setup;

# add source for initial build to download dependency
ADD ./Cargo.toml /src
ADD ./Cargo.lock /src
ADD ./mixer-ngx /src/mixer-ngx
ADD ./mixer-transport /src/mixer-transport
ADD ./mixer-tests /src/mixer-tests
RUN cd /src;cargo build --all



