FROM openjdk:11

ENV TZ: Asia/Tokyo

RUN apt-get update \
      && apt-get install --no-install-recommends -y task-japanese locales-all \
      time \
      binutils \
      groovy \
      php \
      scala && rm -rf /var/lib/apt/lists/*;

ENV LANG=ja_JP.UTF-8
