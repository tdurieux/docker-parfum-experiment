# Dockerfile
FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install dependencies
RUN apt-get install --no-install-recommends -y git build-essential cmake zlib1g-dev libssl-dev python3 python3-pip ruby ruby-dev rpm \
    && gem install --no-ri --no-rdoc fpm && rm -rf /var/lib/apt/lists/*;

WORKDIR /alusus/
