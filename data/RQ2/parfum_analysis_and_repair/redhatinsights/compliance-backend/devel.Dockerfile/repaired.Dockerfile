FROM ruby:3.0-buster

WORKDIR /app
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN apt-get update && \
    apt-get install --no-install-recommends -y qt5-default \
                       libqt5webkit5-dev \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-tools \
                       gstreamer1.0-x \
                       libopenscap-dev \
                       postgresql-client \
                       shared-mime-info \
                       less && \
    gem update bundler && rm -rf /root/.gem; && rm -rf /var/lib/apt/lists/*;

COPY vendor/ ./vendor
COPY Gemfile* ./
COPY devel.entrypoint.sh ./

RUN bundle -j4

ENTRYPOINT ["/app/devel.entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
