FROM ruby:2.4.0
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler jekyll
RUN mkdir /src
COPY ./Gemfile** /src/
WORKDIR /src
RUN bundle install
