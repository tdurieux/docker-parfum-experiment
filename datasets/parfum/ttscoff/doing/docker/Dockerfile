FROM ruby:3.0.1
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN mkdir /doing
WORKDIR /doing
# COPY ./ /doing/
RUN gem install bundler:2.2.17
RUN apt-get update -y
RUN apt-get install -y less vim
COPY ./docker/inputrc /root/.inputrc
COPY ./docker/bash_profile /root/.bash_profile
CMD ["scripts/runtests.sh"]
