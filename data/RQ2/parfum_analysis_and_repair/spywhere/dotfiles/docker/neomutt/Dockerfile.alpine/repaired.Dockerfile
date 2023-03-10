FROM alpine AS builder

WORKDIR /etc/app
RUN apk add --no-cache git build-base openssl libressl-dev libxslt ncurses-dev ncurses-libs libxml2-dev libxml2-utils gettext-dev libidn-dev lua-dev notmuch-dev gpgme-dev cyrus-sasl-dev lmdb-dev krb5-dev pcre2-dev lz4-dev
RUN git clone https://github.com/neomutt/neomutt neomutt
WORKDIR /etc/app/neomutt
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --ssl --notmuch --gpgme --with-ui=ncurses --sasl --gss --lmdb --pcre2 --lz4 --disable-doc
RUN make install

FROM alpine
LABEL DEPS="apk add --no-cache openssl ncurses-libs libidn notmuch gpgme libsasl lmdb krb5 pcre2 lz4-libs python2 w3m"
RUN apk add --no-cache openssl ncurses-libs libidn notmuch gpgme libsasl lmdb krb5 pcre2 lz4-libs python2 w3m
COPY --from=builder /usr/bin/neomutt /usr/bin/neomutt
LABEL BINARY="neomutt"
LABEL TEST="--version"
CMD neomutt
