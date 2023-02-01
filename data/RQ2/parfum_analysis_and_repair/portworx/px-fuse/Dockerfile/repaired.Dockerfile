FROM gcc:latest
MAINTAINER Vinod Jayaraman <jv@portworx.com>

WORKDIR /home/

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
	module-init-tools \
	dh-autoreconf \
	alien \
	rpm && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y dh-autoreconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rpm alien && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;
ADD . /home/px-fuse
WORKDIR /home/px-fuse
RUN autoreconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"

ENTRYPOINT ["/home/px-fuse/fuse-entry-point.sh"]

CMD ["make", "rpm"]
