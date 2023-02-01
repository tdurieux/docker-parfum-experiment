# Docker file to build AnyMeal package for Debian Sid.
#
# configure /etc/default/docker
# DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --ip-masq=true"
FROM debian:sid
MAINTAINER Jan Wedekind <jan@wedesoft.de>
RUN echo "deb http://httpredir.debian.org/debian unstable main" > /etc/apt/sources.list
RUN apt-get update  # Forced update So 7. Nov 20:18:00 GMT 2021
RUN apt-get -q -y dist-upgrade
RUN apt-get install --no-install-recommends -q -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y devscripts equivs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y flex && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y googletest && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y librecode-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y qtbase5-dev-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y qttools5-dev-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y qtbase5-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/src/anymeal && rm -rf /usr/src/anymeal
WORKDIR /usr/src/anymeal
ADD debian/control debian/control
RUN mk-build-deps --install --remove --tool 'apt-get -q --yes' debian/control
COPY anymeal.tar.xz .
COPY anymeal.tar.xz.asc .
ADD configure.ac .
ADD debian debian
ADD Makefile.package .
RUN make -f Makefile.package
RUN dpkg --install pkg/anymeal_*.deb
