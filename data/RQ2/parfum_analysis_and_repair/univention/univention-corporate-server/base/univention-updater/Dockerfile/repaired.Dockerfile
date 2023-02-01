FROM docker-registry.knut.univention.de/phahn/ucs-debbase:500
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /work
COPY ["debian/control", "/work/debian/control"]
RUN apt-get -qq update \
	&& apt-get build-dep -q --assume-yes . \
	&& apt-get clean
COPY [".", "/work"]
RUN dpkg-buildpackage --no-sign -b \
	&& apt-get install -y -q --assume-yes --no-install-recommends ../*.deb \
	&& apt-get clean \
	&& rm -f ../*.deb && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/bin/bash"]

# vim:set filetype=dockerfile:
