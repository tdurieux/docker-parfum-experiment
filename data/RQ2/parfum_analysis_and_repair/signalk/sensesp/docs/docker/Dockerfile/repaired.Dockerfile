FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby-full build-essential zlib1g-dev && rm -rf /var/lib/apt/lists/*;

ENV GEM_HOME="$HOME/gems"
ENV PATH="$HOME/gems/bin:$PATH"

ENV BUNDLE_HOME=/usr/local/bundle
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_DISABLE_PLATFORM_WARNINGS=true
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_BIN=/usr/gem/bin
ENV RUBYOPT=-W0

RUN gem install jekyll bundler

COPY entrypoint /entrypoint

WORKDIR /srv/jekyll

ENTRYPOINT [ "/entrypoint" ]
