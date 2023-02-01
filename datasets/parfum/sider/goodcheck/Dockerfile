FROM rubylang/ruby:2.6.3-bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /goodcheck
WORKDIR /goodcheck
COPY . /goodcheck/
RUN rake install

RUN mkdir /work
WORKDIR /work

ENTRYPOINT ["goodcheck"]
