FROM jfactory/common-slave:latest
MAINTAINER Sławek Piotrowski <sentinel@atteo.com>

USER root

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && rm -rf /var/lib/apt/lists/* \
	&& curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install --no-install-recommends -y nodejs bzip2 libfontconfig build-essential yarn && rm -rf /var/lib/apt/lists/*

USER jenkins
