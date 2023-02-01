FROM untangleinc/ngfw:bullseye-base-multiarch
LABEL maintainer="Sebastien Delafond <sdelafond@gmail.com>"

# do not gzip apt lists files (for apt-show-versions)
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes

RUN apt update -q

# add foreign architectures and their corresponding crossbuild package
RUN dpkg --add-architecture arm64
RUN apt install --no-install-recommends --yes crossbuild-essential-arm64 && rm -rf /var/lib/apt/lists/*;
# RUN dpkg --add-architecture armhf
# RUN apt install --yes crossbuild-essential-armhf

# install required packages
RUN apt install --no-install-recommends --yes build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes debhelper && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes devscripts && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes apt-show-versions && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes openssh-client && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes dput && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes procps && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes gawk && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes apt-utils && rm -rf /var/lib/apt/lists/*;

# cleanup
RUN apt clean
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt-show-versions/*

# do not use official Debian mirrors during build
RUN rm /etc/apt/sources.list

# base dir
ENV UNTANGLE=/opt/untangle
RUN mkdir -p ${UNTANGLE}

# pkgtools
ENV PKGTOOLS=${UNTANGLE}/ngfw_pkgtools
VOLUME ${PKGTOOLS}

# source to build
ENV SRC=/opt/untangle/build
RUN mkdir -p ${SRC}
VOLUME ${SRC}

WORKDIR ${SRC}


CMD [ "bash", "-c", "${PKGTOOLS}/build.sh" ]
