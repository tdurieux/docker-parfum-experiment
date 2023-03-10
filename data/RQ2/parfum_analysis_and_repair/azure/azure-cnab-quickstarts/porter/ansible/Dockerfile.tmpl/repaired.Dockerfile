FROM ubuntu:18.04

# Set encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
	    openssh-client \
        tree \
	    tzdata \
        wget \
        unzip && rm -rf /var/lib/apt/lists/*;

ENV TZ='Europe/London'

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --batch --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | \
        tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        azure-cli \
        jq \
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install required Python environment
RUN pip3 install --no-cache-dir --upgrade \
        pip \
        setuptools \
    && if [ ! -e /usr/bin/python ]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    && pip install --no-cache-dir \
        ansible[azure]

ENV ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3

ARG BUNDLE_DIR

COPY playbook $BUNDLE_DIR/ansible
COPY bundle-script-library.sh $BUNDLE_DIR

RUN chmod +x $BUNDLE_DIR/bundle-script-library.sh
