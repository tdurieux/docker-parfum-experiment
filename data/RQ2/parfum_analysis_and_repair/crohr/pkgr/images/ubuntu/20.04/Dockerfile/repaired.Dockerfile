FROM barebuild/ubuntu:20.04
WORKDIR /app
ARG PKGR_VERSION

RUN curl -f -GLs https://buildcurl.com -d recipe=pkgr -d -d -o - | tar xzf - -C /usr/local
ENTRYPOINT ["/usr/local/bin/pkgr", "package", ".", "--clean", "--auto", "--compile-cache-dir", "/cache"]
