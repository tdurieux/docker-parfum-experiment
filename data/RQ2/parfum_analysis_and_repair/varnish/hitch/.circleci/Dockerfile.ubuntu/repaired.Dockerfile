FROM ubuntu

RUN set -e; \
	export DEBIAN_FRONTEND=noninteractive; \
	export DEBCONF_NONINTERACTIVE_SEEN=true; \
	apt-get update; \
	apt-get install --no-install-recommends -y \
					libev-dev \
					libssl-dev \
					automake \
					python-docutils \
					flex \
					bison \
					pkg-config \
					make && rm -rf /var/lib/apt/lists/*;
