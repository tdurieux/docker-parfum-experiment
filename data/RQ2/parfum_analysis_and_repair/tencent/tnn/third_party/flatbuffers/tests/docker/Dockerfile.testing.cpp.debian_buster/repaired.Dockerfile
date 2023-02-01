FROM debian:10.1-slim as base
RUN apt -qq update >/dev/null
RUN apt -qq --no-install-recommends install -y cmake make build-essential >/dev/null && rm -rf /var/lib/apt/lists/*;
RUN apt -qq --no-install-recommends install -y autoconf git libtool >/dev/null && rm -rf /var/lib/apt/lists/*;
RUN apt -qq --no-install-recommends install -y clang >/dev/null && rm -rf /var/lib/apt/lists/*;
FROM base
# Travis machines have 2 cores. Can be redefined with 'run --env PAR_JOBS=N'.
ENV JOBS=2
WORKDIR /flatbuffers
ADD . .
