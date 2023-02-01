FROM ubuntu:16.04

MAINTAINER Maarten van Meersbergen <m.vanmeersbergen@esciencecenter.nl>
RUN apt-get update -y

RUN apt-get install --no-install-recommends locales -y && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD . /app
WORKDIR /app

RUN npm install -g bower grunt-cli && npm cache clean --force;

RUN apt-get install --no-install-recommends ruby-dev libffi-dev -y && rm -rf /var/lib/apt/lists/*;
RUN gem install compass

RUN npm install && npm cache clean --force;
RUN bower install --allow-root

EXPOSE 9000

CMD grunt serve --force
