FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get install --no-install-recommends -y \
	python3-pip nodejs python-is-python3 \
        libpq-dev python3-dev \
        build-essential git \
        postgresql-client && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade tensorflow && \
    pip3 install --no-cache-dir numpy \
        pandas \
        sklearn \
        matplotlib

ENV SALTCORN_DISABLE_UPGRADE "true"
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD "true"

WORKDIR /opt/saltcorn

COPY . /opt/saltcorn
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm run tsc

ENV PATH "$PATH:/opt/saltcorn/packages/saltcorn-cli/bin/saltcorn"

ENTRYPOINT ["/opt/saltcorn/packages/saltcorn-cli/bin/saltcorn"]