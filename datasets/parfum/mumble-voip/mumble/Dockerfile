FROM ubuntu:focal

# needed to install tzdata
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
	ca-certificates \
	git \
	build-essential \
	cmake \
	pkg-config \
	qt5-default \
	libboost-dev \
	libasound2-dev \
	libssl-dev \
	libspeechd-dev \
	libzeroc-ice-dev \
	libpulse-dev \
	libcap-dev \
	libprotobuf-dev \
	protobuf-compiler \
	libprotoc-dev \
	libogg-dev \
	libavahi-compat-libdnssd-dev \
	libsndfile1-dev \
	libxi-dev \
	libbz2-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY . /root/mumble
WORKDIR /root/mumble/build

RUN git submodule update --init --recursive
RUN cmake -Dclient=OFF -DCMAKE_BUILD_TYPE=Release .. || \
    ( cat \
    /root/mumble/build/CMakeFiles/CMakeOutput.log \
    /root/mumble/build/CMakeFiles/CMakeError.log \
    && false \
    )
RUN make -j $(nproc)

# Clean distribution stage
FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG UID=1000
ARG GID=1000

RUN groupadd --gid $GID murmur \
	&& useradd --uid $UID --gid $GID murmur

RUN apt-get update && apt-get install --no-install-recommends -y \
	libcap2 \
	libzeroc-ice3.7 \
	'^libprotobuf[0-9]+$' \
	libavahi-compat-libdnssd1 \
	libqt5core5a \
	libqt5network5 \
	libqt5sql5 \
	libqt5sql5-mysql \
	libqt5sql5-psql \
	libqt5sql5-sqlite \
	libqt5xml5 \
	libqt5dbus5 \
	ca-certificates \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=0 /root/mumble/build/mumble-server /usr/bin/mumble-server
COPY --from=0 /root/mumble/scripts/murmur.ini /etc/murmur/murmur.ini

RUN mkdir /var/lib/murmur && \
	chown --verbose murmur:murmur /var/lib/murmur && \
	sed -i 's/^database=$/database=\/var\/lib\/murmur\/murmur.sqlite/' /etc/murmur/murmur.ini

EXPOSE 64738/tcp 64738/udp 50051
USER murmur

CMD ["/usr/bin/mumble-server", "-v", "-fg", "-ini", "/etc/murmur/murmur.ini"]
