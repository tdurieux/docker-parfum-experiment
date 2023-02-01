FROM gcc:9.2.0

# Install seccomp
RUN true \
      && apt-get update \
      && apt-get install --no-install-recommends -y libseccomp-dev \
      && rm -rf rm -rf /var/lib/apt/lists/*

COPY Makefile /src/
COPY compile-bpf.c /src/
WORKDIR /src
RUN make
