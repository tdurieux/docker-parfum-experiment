FROM ubuntu:bionic

ENV TZ=Europe/Amsterdam
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
	curl \
	git && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_17.x | bash - \
	&& curl -f -sL https://deb.nodesource.com/setup_17.x | bash - \
	&& curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install --no-install-recommends -y \
	nodejs \
	libcairo2-dev \
	libjpeg-dev \
	libpango1.0-dev \
	libgif-dev \
	libpng-dev \
    librsvg2-dev \
	build-essential \
	g++ && rm -rf /var/lib/apt/lists/*;

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

WORKDIR /usr/src/app

CMD [ "tail", "-f", "/dev/null" ]
