ARG CONTAINER_RUBY_VERSION
FROM ruby:$CONTAINER_RUBY_VERSION

ARG CONTAINER_PG_VERSION

RUN export DEBIAN_CODENAME=$(cat /etc/os-release | grep "VERSION=" | cut -d "(" -f2 | cut -d ")" -f1) && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $DEBIAN_CODENAME-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y --fix-missing --no-install-recommends \
      less \
      postgresql-client-$CONTAINER_PG_VERSION && \
    rm -rf /var/lib/apt/lists/*

RUN curl -f -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/local/bin/cc-reporter && \
    chmod +x /usr/local/bin/cc-reporter

RUN mkdir /code

WORKDIR /code

COPY . /code

RUN gem install rubygems-bundler && \
    bundle install && \
    gem regenerate_binstubs

RUN rm -rf *

ENV PATH "/code/bin:$PATH"

CMD /bin/sleep infinity
