ARG	REGISTRY=docker.io
FROM	${REGISTRY}/debian:bullseye
# Arguments used after FROM must be specified again
ARG	OSMOCOM_REPO_MIRROR="https://downloads.osmocom.org"
ARG	OSMOCOM_REPO_PATH="packages/osmocom:"
ARG	OSMOCOM_REPO="${OSMOCOM_REPO_MIRROR}/${OSMOCOM_REPO_PATH}/latest/Debian_11/"

# install the erlang vm and rebar (2)
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get -y --no-install-recommends install \
		erlang \
		rebar && rm -rf /var/lib/apt/lists/*;

# add rebar3
ARG	REBAR3_VERSION="3.18.0"
ADD https://github.com/erlang/rebar3/archive/refs/tags/${REBAR3_VERSION}.tar.gz /tmp/rebar3.tar.gz
RUN tar -zxf /tmp/rebar3.tar.gz && \
		cd rebar3-${REBAR3_VERSION} && \
		./bootstrap && \
		install -Dm0755 "rebar3" "/usr/bin/rebar3" && rm /tmp/rebar3.tar.gz

# install ninimal build utilities as well as system utilities
RUN apt-get update && \
	apt-get -y --no-install-recommends install \
		build-essential \
		git \
		procps \
		tcpdump \
		vim \
		netcat-openbsd \
		wget \
		&& \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

# install additional C-language / system dependencies of our Erlang projects
RUN apt-get update && \
	apt-get -y --no-install-recommends install \
		libpcap-dev \
		&& \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

# add osmocom latest repo, should we ever require packages from there
RUN apt-get update && apt-get install --no-install-recommends -y \
		ca-certificates \
		gnupg && rm -rf /var/lib/apt/lists/*;
COPY	.common/Release.key /tmp/Release.key
RUN	apt-key add /tmp/Release.key && \
	rm /tmp/Release.key && \
	echo "deb " $OSMOCOM_REPO " ./" > /etc/apt/sources.list.d/osmocom-latest.list
ADD	$OSMOCOM_REPO/Release /tmp/Release

# add a non-root user under which we will normaly execute build tests
RUN	useradd -m build
WORKDIR	/home/build
USER	build
