FROM ubuntu:jammy

# Fix add-apt-repository is broken with non-UTF-8 locales, see https://github.com/oerdnj/deb.sury.org/issues/56
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    # Configure ondrej PPA
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get upgrade -y && rm -rf /var/lib/apt/lists/*;

# Fix add-apt-repository is broken with non-UTF-8 locales, see https://github.com/oerdnj/deb.sury.org/issues/56
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN echo "Building base Linux..." && \
    # Configure ondrej PPA
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get upgrade -y && \
    #
    # Install PHP & curl (for composer)
    apt-get install -y --no-install-recommends \
        curl git ssh  \
        less vim inetutils-ping zip unzip net-tools && rm -rf /var/lib/apt/lists/*;

WORKDIR /workdir

ENTRYPOINT ["bash", "-l"]
