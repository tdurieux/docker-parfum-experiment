FROM ubuntu

RUN set -e; \
	export DEBIAN_FRONTEND=noninteractive; \
	export DEBCONF_NONINTERACTIVE_SEEN=true; \
	apt-get update; \
	apt-get install --no-install-recommends -y \
					autoconf \
					automake \
					build-essential \
					ca-certificates \
					cpio \
					git \
					graphviz \
					libedit-dev \
					libjemalloc-dev \
					libncurses-dev \
					libpcre2-dev \
					libtool \
					libunwind-dev \
					pkg-config \
					python3-sphinx && rm -rf /var/lib/apt/lists/*;
