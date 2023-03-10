FROM ubuntu:latest

ENV TZ: Asia/Tokyo
RUN apt-get update \
      && apt-get install --no-install-recommends -y ruby \
      python \
      python3 \
      clang \
      gcc \
      g++ \
      golang \
      nodejs \
      lua5.3 \
      haskell-platform \
      npm \
      lazarus \
      time \
      binutils \
      swi-prolog \
      openjdk-8-jre \
      scala \
      language-pack-ja-base language-pack-ja && rm -rf /var/lib/apt/lists/*;

RUN npm install -g typescript && npm cache clean --force;

ENV LANG=ja_JP.UTF-8
