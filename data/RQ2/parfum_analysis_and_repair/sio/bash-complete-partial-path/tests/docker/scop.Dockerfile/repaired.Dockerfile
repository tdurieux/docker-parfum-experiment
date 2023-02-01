# Test environment that provides https://github.com/scop/bash-completion

FROM ghcr.io/sio/bash-complete-partial-path:debian-10

RUN \
    apt-get install --no-install-recommends -y bash-completion && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV BCPP_TEST_SCOP_COMPLETION /etc/bash_completion
