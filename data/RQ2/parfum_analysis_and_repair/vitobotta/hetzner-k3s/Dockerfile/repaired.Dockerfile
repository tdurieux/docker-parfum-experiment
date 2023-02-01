FROM ruby:3.1.2-alpine

RUN apk update --no-cache \
  && apk add --no-cache build-base git openssh-client curl bash

RUN curl -f -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

COPY . .

RUN gem install hetzner-k3s

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

