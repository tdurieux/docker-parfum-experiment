FROM rust:1.62 as build
WORKDIR /workspace
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILD_TARGET=debug
ARG MAKE_TARGET=build
COPY . /workspace
RUN suffix=$(echo ${TARGETPLATFORM} | sed "s/\//-/g") && \
    apt update && \
    apt install --no-install-recommends -y sudo && \
    make setup-dev && \
    make ${MAKE_TARGET} && \
    apt-get clean && \
    rustup self uninstall -y && \
    cp target/${BUILD_TARGET}/huber target/${BUILD_TARGET}/huber-${suffix} && rm -rf /var/lib/apt/lists/*;

FROM scratch
ARG BUILD_TARGET=debug
COPY --from=build /workspace/target/${BUILD_TARGET}/huber-* /target/
