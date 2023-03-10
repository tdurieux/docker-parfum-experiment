FROM ruby:2.6-alpine
MAINTAINER Matt Conway <matt@simplygenius.com>

ENV APP_DIR /atmos
ENV RUN_DIR /app
ENV BUNDLE_PATH /srv/bundler
ENV BUNDLE_BIN=${BUNDLE_PATH}/bin
ENV GEM_HOME=${BUNDLE_PATH}
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV TF_VER=0.11.14
ENV TF_PKG=https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip

RUN mkdir -p $APP_DIR $RUN_DIR
WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock *.gemspec $APP_DIR/
COPY lib/simplygenius/atmos/version.rb $APP_DIR/lib/simplygenius/atmos/

ENV BUILD_PACKAGES="build-base ruby-dev"
ENV APP_PACKAGES="bash curl git docker"

RUN apk --update upgrade && \
    apk add \
      --virtual app \
      $APP_PACKAGES && \
    apk add \
      --virtual build_deps \
      $BUILD_PACKAGES && \
    apk add aws-cli --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    bundle install && \
    apk del build_deps && \
    rm -rf /var/cache/apk/*

RUN curl -f -sL $TF_PKG > terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin && \
    rm -f terraform.zip

COPY . $APP_DIR/
RUN bundle install

WORKDIR $RUN_DIR
VOLUME $RUN_DIR

ENV BUNDLE_GEMFILE=$APP_DIR/Gemfile
ENTRYPOINT ["bundle", "exec", "atmos"]
