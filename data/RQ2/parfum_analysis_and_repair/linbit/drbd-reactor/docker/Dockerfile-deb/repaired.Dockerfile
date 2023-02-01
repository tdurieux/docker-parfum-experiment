FROM debian:bullseye
MAINTAINER Roland Kammerer <roland.kammerer@linbit.com>

RUN apt-get update && \
	apt-get install --no-install-recommends -y gcc curl dh-python bash-completion devscripts cargo rustc && \
	apt-get install --no-install-recommends -y python3-pip python3-toml && pip3 install --no-cache-dir -U shtab && \
	apt-get clean -y && rm -rf /var/lib/apt/lists/*;
