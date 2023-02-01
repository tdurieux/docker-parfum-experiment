FROM debian:10

MAINTAINER Li Yichao <liyichao.good@gmail.com>


RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	build-essential \
	libtool \
	automake && rm -rf /var/lib/apt/lists/*;

WORKDIR /kids

COPY . /kids
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

EXPOSE :3388

CMD ["src/kids", "-c", "/kids/debian/kids.conf"]
