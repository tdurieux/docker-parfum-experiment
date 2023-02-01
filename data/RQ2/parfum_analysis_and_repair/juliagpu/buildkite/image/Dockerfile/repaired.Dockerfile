ARG base=ubuntu:latest
FROM $base

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl wget apt-transport-https openssl gnupg2 python3 && rm -rf /var/lib/apt/lists/*;

RUN wget -O- https://keys.openpgp.org/vks/v1/by-fingerprint/32A37959C2FA5C3C99EFBC32A79206696452D198 > \
      /tmp/buildkite-agent-archive-keyring.gpg && \
    bash -c "cat /tmp/buildkite-agent-archive-keyring.gpg | \
      gpg --dearmor > /usr/share/keyrings/buildkite-agent-archive-keyring.gpg" && \
    echo "deb [signed-by=/usr/share/keyrings/buildkite-agent-archive-keyring.gpg] https://apt.buildkite.com/buildkite-agent stable main" > \
      /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y buildkite-agent && rm -rf /var/lib/apt/lists/*;

COPY secrets.private.key /
COPY hooks /hooks

ENTRYPOINT ["buildkite-agent"]
CMD ["start"]
