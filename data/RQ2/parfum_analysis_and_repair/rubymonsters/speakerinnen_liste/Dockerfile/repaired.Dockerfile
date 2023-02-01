FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN mkdir /speakerinnen_liste
WORKDIR /speakerinnen_liste
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler
