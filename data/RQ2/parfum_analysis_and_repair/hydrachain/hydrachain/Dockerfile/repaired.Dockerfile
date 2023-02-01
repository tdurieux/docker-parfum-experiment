FROM python:2.7.10

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl git-core && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libgmp-dev rsync && rm -rf /var/lib/apt/lists/*;

WORKDIR /
ADD . hydrachain

RUN pip install --no-cache-dir -U setuptools
# Pre-install hydrachain dependency
RUN pip install --no-cache-dir secp256k1==0.12.1

WORKDIR /hydrachain
# Reset potentially dirty directory and remove after install
RUN git reset --hard && pip install --no-cache-dir . && cd .. && rm -rf /hydrachain
WORKDIR /

ENTRYPOINT ["/usr/local/bin/hydrachain"]
CMD ["run"]
