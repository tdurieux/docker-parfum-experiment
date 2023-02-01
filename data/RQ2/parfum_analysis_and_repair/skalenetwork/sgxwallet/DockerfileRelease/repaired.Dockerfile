FROM skalenetwork/sgxwallet_base:latest

COPY . /usr/src/sdk
WORKDIR /usr/src/sdk
RUN cp -f secure_enclave/secure_enclave.config.xml.release secure_enclave/secure_enclave.config.xml
RUN apt update && apt install --no-install-recommends -y curl secure-delete && rm -rf /var/lib/apt/lists/*;
RUN touch /var/hwmode
RUN ./autoconf.bash
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-sgx-build=release
RUN bash -c "make -j$(nproc)"
RUN ccache -sz
RUN cd scripts && ./sign_enclave.bash
RUN mkdir -p /usr/src/sdk/sgx_data && rm -rf /usr/src/sdk/sgx_data
COPY docker/start.sh ./
RUN rm -rf /usr/src/sdk/sgx-sdk-build/
RUN rm /opt/intel/sgxsdk/lib64/*_sim.so
RUN rm /usr/src/sdk/secure_enclave/secure_enclave*.so
RUN cp signed_enclaves/secure_enclave_signed0.so secure_enclave/secure_enclave.signed.so
ENTRYPOINT ["/usr/src/sdk/start.sh"]
