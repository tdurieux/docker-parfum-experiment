FROM debian:8
MAINTAINER Juan Manuel Torres <juanmanuel.torres@aventurabinaria.es>

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \
		sudo \
		python-setuptools \
		python-support \
		python-yaml \
		gcc \
		make \
		build-essential \
		libssl-dev \
		libffi-dev \
		unicode \
		python-unicodecsv \
		g++ \
		python-dev \
		libtool \
		pkg-config \
		locales \
		nano \
		dnsutils \
		mysql-client \
		postgresql-client \
		nmap \
		telnet \
		netcat \
		python3 \
		lsb-release && rm -rf /var/lib/apt/lists/*;

RUN export GCSFUSE_REPO=gcsfuse-jessie \
    && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list \
    && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends gcsfuse -y \
    && export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends google-cloud-sdk -y \
    && curl -f -o /tmp/kubectl -SL https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl \
    && chmod +x /tmp/kubectl \
    && mv /tmp/kubectl /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/*;


