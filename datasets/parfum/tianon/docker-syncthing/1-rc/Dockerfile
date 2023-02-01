FROM alpine:3.11

RUN addgroup -g 1000 user && adduser -u 1000 -G user -D user

RUN apk add --no-cache ca-certificates

# gpg: key 00654A3E: public key "Syncthing Release Management <release@syncthing.net>" imported
ENV SYNCTHING_GPG_KEY 37C84554E7E0A261E4F76E1ED26E6ED000654A3E

ENV SYNCTHING_VERSION 1.20.4-rc.1

RUN set -x \
	&& apk add --no-cache --virtual .temp-deps \
		gnupg \
		libressl \
	&& tarball="syncthing-linux-amd64-v${SYNCTHING_VERSION}.tar.gz" \
	&& wget \
		"https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/$tarball" \
		"https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/sha1sum.txt.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${SYNCTHING_GPG_KEY}" \
	&& gpg --batch --decrypt --output sha1sum.txt sha1sum.txt.asc \
	&& grep -E " ${tarball}\$" sha1sum.txt | sha1sum -c - \
	&& gpgconf --kill all \
	&& rm -r "$GNUPGHOME" sha1sum.txt sha1sum.txt.asc \
	&& dir="$(basename "$tarball" .tar.gz)" \
	&& bin="$dir/syncthing" \
	&& tar -xvzf "$tarball" "$bin" \
	&& rm "$tarball" \
	&& mv "$bin" /usr/local/bin/syncthing \
	&& rmdir "$dir" \
	&& apk del .temp-deps \
# smoke test
	&& syncthing -help

USER user
CMD ["syncthing"]
