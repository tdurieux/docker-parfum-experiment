FROM debian:jessie
MAINTAINER Jessie Frazelle <jess@docker.com>

RUN apt-get update && apt-get install -y \
	ca-certificates \
	curl \
	s3cmd \
	--no-install-recommends

ENV HUGO_VERSION 0.13
RUN curl -sSL https://github.com/spf13/hugo/releases/download/v0.13/hugo_${HUGO_VERSION}_linux_amd64.tar.gz | tar -v -C /usr/local/bin -xz --strip-components 1 && \
	mv /usr/local/bin/hugo_${HUGO_VERSION}_linux_amd64 /usr/local/bin/hugo

# Setup s3cmd config
RUN { \
    echo '[default]'; \
    echo 'access_key=$AWS_ACCESS_KEY'; \
    echo 'secret_key=$AWS_SECRET_KEY'; \
    } > ~/.s3cfg

WORKDIR /usr/src/birthdaysite/

# add files
COPY . /usr/src/birthdaysite/

ENTRYPOINT [ "./release.sh" ]
