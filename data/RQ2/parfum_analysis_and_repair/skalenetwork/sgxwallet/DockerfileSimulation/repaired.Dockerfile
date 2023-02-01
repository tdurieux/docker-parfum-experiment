FROM skalenetwork/sgxwallet_base:latest


RUN apt update && apt install --no-install-recommends -y curl secure-delete && rm -rf /var/lib/apt/lists/*;

RUN ccache -sz

COPY . /usr/src/sdk
WORKDIR /usr/src/sdk
RUN cp -f secure_enclave/secure_enclave.config.xml.sim secure_enclave/secure_enclave.config.xml
RUN ./autoconf.bash && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-sgx-simulation && \
    bash -c "make" && \
    ccache -sz && \
    mkdir -p /usr/src/sdk/sgx_data && rm -rf /usr/src/sdk/sgx_data

COPY docker/start.sh ./
RUN rm -rf /usr/src/sdk/sgx-sdk-build/

ENTRYPOINT ["/usr/src/sdk/start.sh"]
