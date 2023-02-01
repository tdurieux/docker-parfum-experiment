FROM golang:1.9 as build
RUN apt-get update && apt-get install --no-install-recommends -y git ca-certificates build-essential && rm -rf /var/lib/apt/lists/*;
RUN cd / && git clone https://github.com/containernetworking/plugins && \
    cd plugins && bash build.sh

FROM scratch
COPY --from=build /plugins/bin/* /bin/
