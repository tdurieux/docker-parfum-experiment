FROM ruby:2.3.3

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# https://superuser.com/q/1423486/366168
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update \
    && apt-get install --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm -y && rm -rf /var/lib/apt/lists/*;

ADD . /usr/src/app
WORKDIR /usr/src/app
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rails", "s", "-p", "8080", "-b", "0.0.0.0"]
