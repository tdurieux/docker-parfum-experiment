FROM ruby:2.3.3-slim
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem install bundler && gem update bundler && \
      apt-get update && \
      apt-get install -y --no-install-recommends \
      build-essential nodejs less \
      libnetcdf-dev libmysqlclient-dev libxml2-dev && \
      rm -rf /var/lib/apt/lists/* && rm -rf /root/.gem;

ENV APP_PATH /app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

ARG bundle_jobs

ENV BUNDLE_JOBS=$bundle_jobs

COPY . $APP_PATH
