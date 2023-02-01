FROM frolvlad/alpine-glibc
# Environmental preparation
COPY ./build/wasm/lib/linux-amd64/libwasmer.so /lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib

WORKDIR /root/.bitxhub

# Copy essential binaries from build
COPY ./bin/bitxhub /usr/local/bin/

# Generate configuration
RUN bitxhub --repo=/root/.bitxhub init \
    && sed -i "s/solo = false/solo = true/g" ./bitxhub.toml \
    && sed -i "s/raft/solo/g" ./bitxhub.toml

EXPOSE 8881 60011 9091 53121 40011

CMD ["bitxhub", "start"]