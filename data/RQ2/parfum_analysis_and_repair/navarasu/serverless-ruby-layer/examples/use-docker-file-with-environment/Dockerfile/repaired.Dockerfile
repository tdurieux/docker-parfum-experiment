FROM lambci/lambda:build-ruby2.7
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update bundler && rm -rf /root/.gem;

ARG USE_HTTPARTY
ENV USE_HTTPARTY=${USE_HTTPARTY}
ARG NOKOGIRI_VERSION
ENV NOKOGIRI_VERSION=${NOKOGIRI_VERSION}

CMD "/bin/bash"

