FROM ubuntu
MAINTAINER Shaun Jackman <sjackman@gmail.com>

RUN apt-get update \
	&& apt-get install --no-install-recommends -y curl g++ git make ruby2.0 ruby2.0-dev \
	&& ln -sf ruby2.0 /usr/bin/ruby \
	&& ln -sf gem2.0 /usr/bin/gem && rm -rf /var/lib/apt/lists/*;

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m -s /bin/bash linuxbrew \
	&& echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
ADD . /home/linuxbrew/.linuxbrew
RUN chown -R linuxbrew: /home/linuxbrew/.linuxbrew \
	&& cd /home/linuxbrew/.linuxbrew \
	&& git remote set-url origin https://github.com/Linuxbrew/linuxbrew.git

USER linuxbrew
WORKDIR /home/linuxbrew
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash
