# Build from the same version of ubuntu as phusion/baseimage
FROM @@image@@

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y zlib1g-dev \
                       liblzma-dev && rm -rf /var/lib/apt/lists/*;

ENV BUNDLER_VERSION 2.2.30
RUN gem install --no-document bundler:$BUNDLER_VERSION fpm

RUN mkdir -p /src/opt/conjur/project

WORKDIR /src/opt/conjur/project

COPY Gemfile \
     Gemfile.lock ./
COPY gems/ gems/

COPY . .

# removing CA bundle of httpclient gem
RUN find / -name httpclient -type d -exec find {} -name *.pem -type f -delete \;

ADD debify.sh /

WORKDIR /src
