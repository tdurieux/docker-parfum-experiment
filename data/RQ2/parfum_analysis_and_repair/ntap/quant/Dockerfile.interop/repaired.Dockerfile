FROM martenseemann/quic-network-simulator-endpoint as qns
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y \
        cmake \
        g++ \
        git \
        libhttp-parser-dev \
        libssl-dev \
        pkg-config && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
FROM qns
ADD . /src
WORKDIR /src/Debug
RUN cmake ..
RUN make install

FROM martenseemann/quic-network-simulator-endpoint
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y \
        binutils \
        libasan5 \
        libhttp-parser2.9 \
        libubsan1 && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=1 /usr/local /usr/local
COPY --from=1 /src/Debug/test/dummy.* /tls/
ADD ./test/interop.sh /run_endpoint.sh
RUN chmod +x run_endpoint.sh
ENTRYPOINT [ "/run_endpoint.sh" ]
