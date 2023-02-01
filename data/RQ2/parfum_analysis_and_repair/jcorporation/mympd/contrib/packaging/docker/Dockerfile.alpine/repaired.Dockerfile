#
# SPDX-License-Identifier: GPL-3.0-or-later
# myMPD (c) 2018-2022 Juergen Mang <mail@jcgames.de>
# https://github.com/jcorporation/mympd
#
FROM alpine:latest as build
COPY . /myMPD/
ENV DESTDIR=/myMPD-dist
RUN mkdir -p $DESTDIR
WORKDIR /myMPD
RUN ./build.sh installdeps
ENV MANPAGES=OFF
RUN ./build.sh releaseinstall
WORKDIR /
RUN tar -czvf /mympd.tar.gz -C /myMPD-dist . && rm /mympd.tar.gz

FROM alpine:latest
ENV MPD_HOST=127.0.0.1
ENV MPD_PORT=6600
# hadolint ignore=DL3008
RUN apk add --no-cache openssl libid3tag flac lua5.4 pcre2
# hadolint ignore=DL3010
COPY --from=build /mympd.tar.gz /
WORKDIR /
RUN tar -xzvf mympd.tar.gz -C / && rm mympd.tar.gz
RUN rm mympd.tar.gz
RUN addgroup -S mympd 2>/dev/null
RUN adduser -S -D -H -h /var/lib/mympd -s /sbin/nologin -G mympd -g myMPD mympd 2>/dev/null
ENTRYPOINT ["/usr/bin/mympd"]
