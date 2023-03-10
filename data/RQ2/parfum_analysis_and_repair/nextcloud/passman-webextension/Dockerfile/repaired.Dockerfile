FROM node:lts-stretch-slim

# Install Ruby & Bourbon
# Only required once to init project
# RUN apk update && apk upgrade && apk --update add \
#     ruby ruby-dev ruby-ffi ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
#     libstdc++ tzdata bash ca-certificates \
#     && echo 'gem: --no-document' > /etc/gemrc
# RUN gem install bourbon

RUN apt-get update && \
    apt-get install --no-install-recommends -y chromium firefox-esr && \
    rm -rf /var/lib/apt/ && rm -rf /var/lib/apt/lists/*;

# Install node packages
RUN npm install -g grunt-cli && npm cache clean --force;

# Environment vars
ENV DOCKER="True"

# Copy files
RUN mkdir -p /passman
WORKDIR /passman
COPY . /passman

# Install project dependencies
RUN npm install && npm cache clean --force;
