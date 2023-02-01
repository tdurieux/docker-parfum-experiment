FROM ruby:2.4-stretch

ENV TZ Europe/Berlin
ENV LANG en_US.UTF-8

RUN apt-get update -qq && apt-get install --no-install-recommends -y locales-all build-essential htop vim curl telnet mc bwm-ng net-tools mtr-tiny ssh rsync && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y

RUN groupadd --gid 1000 web && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash web



WORKDIR /home/web/app

USER web
