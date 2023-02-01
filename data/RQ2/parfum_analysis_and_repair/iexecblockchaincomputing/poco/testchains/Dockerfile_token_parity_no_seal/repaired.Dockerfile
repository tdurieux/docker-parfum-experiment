FROM parity/parity:stable

USER root

RUN apt update && apt install --no-install-recommends -y curl git ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN bash -i -c "nvm install 14"
RUN apt install --no-install-recommends -y python2.7 python-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /iexec-poco
COPY . /iexec-poco
RUN mv /iexec-poco/config/config_token.json /iexec-poco/config/config.json

ARG DEV_NODE
ARG MNEMONIC

RUN bash /iexec-poco/testchains/parity/1sec_no_seal/migrate-all.sh

ENTRYPOINT ["/bin/parity"]
CMD ["--chain", "/iexec-poco/testchains/parity/1sec_no_seal/spec.json", "--config", "/iexec-poco/testchains/parity/1sec_no_seal/authority.toml", "-d", "/iexec-poco/testchains/parity/1sec_no_seal/data", "--geth"]
