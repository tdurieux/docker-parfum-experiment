FROM ubuntu:latest AS builder
RUN apt-get update && apt-get -y --no-install-recommends install build-essential intltool libtool m4 automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libjack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libglib2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /src/alsaplayer
COPY . .
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make install
