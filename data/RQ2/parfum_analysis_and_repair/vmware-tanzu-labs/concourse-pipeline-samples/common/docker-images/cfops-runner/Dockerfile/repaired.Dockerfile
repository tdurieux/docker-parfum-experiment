FROM ubuntu:14.04

ENV LAST_UPDATE=2017-03-01

# Install.
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y ruby ruby-dev && \
  wget https://github.com/pivotalservices/cfops/releases/download/v3.0.5/cfops && \
  mv cfops /usr/bin && \
  gem install cf-uaac && \
 
lo aledef -i en_US -f UTF-8 en_US \
    && useradd -m -s /bin/bash pcfdev \ && rm -rf /var/lib/apt/lists/*;

USER pcfdev
