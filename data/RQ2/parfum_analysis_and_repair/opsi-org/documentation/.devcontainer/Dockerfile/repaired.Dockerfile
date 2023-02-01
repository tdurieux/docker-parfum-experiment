FROM docker.uib.gmbh/fabian/opsidoc-antora:latest AS opsidoc-dev-container

LABEL maintainer Fabian Kalweit <f.kalweit@uib.de>

ARG USER

ENV USER=${USER}

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install --no-install-recommends -y gcc \
	git \
	bash-completion \
	sudo \
	make \
	python2 \
	python3 \
	build-essential \
	curl \
	vim && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
	&& sudo apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN gem install sass \
	&& gem install rouge \
	&& gem install asciidoctor-interdoc-reftext

WORKDIR /home
