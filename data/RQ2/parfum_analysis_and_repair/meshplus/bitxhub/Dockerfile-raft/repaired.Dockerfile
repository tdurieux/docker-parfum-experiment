FROM frolvlad/alpine-glibc
# Environmental preparation
COPY ./build/wasm/lib/linux-amd64/libwasmer.so /lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib
WORKDIR /root/.bitxhub

# Copy essential binaries from build
COPY ./build/bitxhub /usr/local/bin/

# Generate configuration
RUN bitxhub --repo=/root/.bitxhub init

EXPOSE 8881 60011 9091 53121 40011

CMD ["bitxhub", "start"]