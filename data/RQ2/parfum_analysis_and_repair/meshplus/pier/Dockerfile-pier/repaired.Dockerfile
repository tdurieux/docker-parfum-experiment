FROM frolvlad/alpine-glibc
# Environmental preparation
COPY ./build/wasm/lib/darwin-amd64/libwasmer.so /lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib
RUN mkdir -p /root/.pier/plugins
WORKDIR /root/.pier

# Copy essential binaries from the bin
COPY ./bin/pier /usr/local/bin/

# Generate configuration
RUN pier --repo=/root/.pier init

EXPOSE 44555 44544

CMD ["pier", "start"]