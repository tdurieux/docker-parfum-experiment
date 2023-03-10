FROM ruby:2.3.1-alpine
MAINTAINER nownabe

RUN apk add --update --no-cache build-base

# Install nasm
ENV build_deps 'curl'
RUN apk add --update --no-cache ${build_deps} \
  && curl -f -SL -O http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.gz \
  && tar zxf nasm-2.12.02.tar.gz \
  && cd nasm-2.12.02 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && apk del ${build_deps} \
  && rm -rf nasm-2.12.02* && rm nasm-2.12.02.tar.gz

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

EXPOSE 80
ENV PORT 80

CMD bundle exec puma -e production -p $PORT
