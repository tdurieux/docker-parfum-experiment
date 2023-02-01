FROM ubuntu:20.04

MAINTAINER hydai hydai@secondstate.io
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
	&& apt install --no-install-recommends -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"

RUN apt update && apt install --no-install-recommends -y \
	docker-ce \
	docker-ce-cli \
	containerd.io && rm -rf /var/lib/apt/lists/*;
