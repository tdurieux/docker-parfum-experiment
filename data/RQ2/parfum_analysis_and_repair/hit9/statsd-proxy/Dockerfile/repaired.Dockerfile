FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
        autoconf && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
EXPOSE 8125
CMD ./statsd-proxy -f ./example.cfg

