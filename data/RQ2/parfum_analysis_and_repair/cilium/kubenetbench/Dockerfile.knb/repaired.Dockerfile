# All-in-one container for kubenetbench.
FROM debian:sid

RUN \
  sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list    \
  && apt -y update                                                     \
  && apt -y dist-upgrade \
  && apt -y --no-install-recommends install procps net-tools strace \
  && apt -y --no-install-recommends install netcat socat netperf iperf \
  && exit 0 && rm -rf /var/lib/apt/lists/*;

COPY scripts scripts

# Run the server by default
CMD ["netserver"]
