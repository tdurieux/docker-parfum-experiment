FROM golang:1.16.11-stretch AS builder
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget jq hwloc ocl-icd-opencl-dev git libhwloc-dev pkg-config make && \
    apt-get install --no-install-recommends -y cargo && rm -rf /var/lib/apt/lists/*;
WORKDIR /app/
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo --help
RUN git clone https://github.com/application-research/estuary . && \
    RUSTFLAGS="-C target-cpu=native -g" FFI_BUILD_FROM_SOURCE=1 FFI_USE_BLST_PORTABLE=1 make
RUN cp ./estuary ./estuary-shuttle ./benchest ./bsget ./shuttle-proxy /usr/local/bin

FROM golang:1.16.11-stretch
RUN apt-get update && \
    apt-get install --no-install-recommends -y hwloc libhwloc-dev ocl-icd-opencl-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /app/estuary /usr/local/bin
COPY --from=builder /app/estuary-shuttle /usr/local/bin
COPY --from=builder /app/benchest /usr/local/bin
COPY --from=builder /app/bsget /usr/local/bin
COPY --from=builder /app/shuttle-proxy /usr/local/bin
