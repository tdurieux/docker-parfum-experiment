FROM golang:latest

# First, add npm as well
# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN set -ex \
	&& for key in \
		7937DFD2AB06298B2293C3187D33FF9D0246406D \
		114F43EE0176B71C7BC219DD50A3051F888C628D \
	; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

ENV NODE_VERSION 0.12.7
ENV NPM_VERSION 2.13.3

RUN set -x \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear

# Add ClamAV lib
RUN apt-get update && apt-get install -y libclamav-dev --no-install-recommends

COPY build-date /
COPY Makefile /
COPY _analytics.jade /
COPY _ze.jade /
COPY _gtmid.json /
WORKDIR /
RUN make setup
RUN make buildgo
RUN make buildgoav

CMD tar -chf - -C /go/src/github.com/demisto/alfred alfred -C /etc/ssl/certs ca-certificates.crt -C /go/src/github.com/demisto/alfred worker -C / build-date
