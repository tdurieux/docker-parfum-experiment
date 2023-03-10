FROM ruby:2.4-alpine
LABEL maintainer="namatyage@gmail.com"

ARG REPOSITORY="https://github.com/tyage/slack-patron.git"
ARG BRANCH="master"
ARG SRCDIR="/usr/local/slack-patron"

RUN set -x && \
	apk upgrade --update && \
	apk add --no-cache --update \
		git \
		build-base \
		openssl \
		nodejs \
		nodejs-npm && \
	echo 'gem: --no-document' >> /etc/gemrc && \
	git clone ${REPOSITORY} ${SRCDIR} && \
	cd ${SRCDIR} && \
	git checkout ${BRANCH} && \
	bundle install && \
	./viewer/setup.sh

WORKDIR ${SRCDIR}

CMD bundle exec rackup viewer/config.ru -o 0.0.0.0 -p 9292

EXPOSE 9292
