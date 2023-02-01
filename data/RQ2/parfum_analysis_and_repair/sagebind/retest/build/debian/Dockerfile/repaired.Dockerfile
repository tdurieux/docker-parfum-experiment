FROM jimmycuadra/rust:latest
MAINTAINER Jimmy Cuadra <jimmy@jimmycuadra.com>

RUN apt-get update && apt-get install -y \
    build-essential \
    fakeroot \
    lintian \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /source
ENTRYPOINT ["/source/build/debian/mkdeb.sh"]
