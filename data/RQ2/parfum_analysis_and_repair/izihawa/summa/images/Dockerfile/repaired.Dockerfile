FROM ubuntu:22.04 as build-env
RUN apt install -y --no-install-recommends zlib1g && rm -rf /var/lib/apt/lists/*;

FROM gcr.io/distroless/cc
COPY --from=build-env /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
