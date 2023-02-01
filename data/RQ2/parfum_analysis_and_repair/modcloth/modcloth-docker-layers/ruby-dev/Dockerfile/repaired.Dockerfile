FROM quay.io/modcloth/build-essential:latest
MAINTAINER Dan Buch <d.buch@modcloth.com>

RUN curl -f -L https://get.rvm.io | bash -s stable
