FROM ubuntu:17.10

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python-software-properties \
        nodejs \
        npm && rm -rf /var/lib/apt/lists/*;

RUN npm install -g ethereumjs-testrpc && npm cache clean --force;

EXPOSE 8545
ENTRYPOINT ["testrpc", \
                "--deterministic", \
                "--mnemonic=master square whisper diet hunt stick please version already attack project aunt" \
            ]