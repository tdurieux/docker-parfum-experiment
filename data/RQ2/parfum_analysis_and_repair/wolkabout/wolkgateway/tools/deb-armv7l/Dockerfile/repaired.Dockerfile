FROM arm32v7/debian:buster

WORKDIR /build

ENV TZ=Europe/Belgrade
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install --no-install-recommends -y git gcc g++ cmake pkg-config automake autotools-dev autoconf m4 zlib1g-dev \
 cmake libtool libssl-dev devscripts debhelper libsqlite3-dev libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

COPY make_deb.sh /build
COPY *.zip /build

#CMD ["bash", "make_deb.sh"]
