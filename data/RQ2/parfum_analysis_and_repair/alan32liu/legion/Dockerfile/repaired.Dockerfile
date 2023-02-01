FROM ubuntu:20.04

WORKDIR /root
COPY Legion.py Makefile tracejump.py __trace_jump.s __VERIFIER.c __VERIFIER_assume.c __trace_buffered.c  /root/

RUN apt-get update \
    && apt-get install --no-install-recommends git -y \
    && apt-get install --no-install-recommends python3 -y \
    && apt-get install --no-install-recommends python3-pip -y \
    && git clone https://github.com/Alan32Liu/claripy.git \
    && git clone https://github.com/Alan32Liu/angr.git \
    && pip3 install --no-cache-dir -e /root/claripy \
    && pip3 install --no-cache-dir -e /root/angr && rm -rf /var/lib/apt/lists/*;

# RUN mkdir -p /root/sv-benchmarks/c
# COPY sv-benchmarks/c /root/sv-benchmarks/c
