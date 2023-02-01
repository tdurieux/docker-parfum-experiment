FROM trailofbits/polytracker
MAINTAINER Carson Harmon <carson.harmon@trailofbits.com>

WORKDIR /polytracker/the_klondike

ENV CC=clang
ENV CXX=clang++

RUN apt update

#Set up sources list to auto get build-dep
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

#Update pkg-config/util-linux (needed for FontConfig)
RUN apt update
RUN apt install --no-install-recommends pkg-config uuid-dev gperf libtool \
	gettext autopoint autoconf -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends python3-dev && rm -rf /var/lib/apt/lists/*;

#RUN apt-get build-dep libpoppler73 -y

#Fontconfig requires some stuff?
RUN apt install --no-install-recommends pkg-config libasound2-dev libssl-dev cmake libfreetype6-dev libexpat1-dev libxcb-composite0-dev -y && rm -rf /var/lib/apt/lists/*;
#RUN apt install libxml2-dev -y

RUN echo "temp" > /PLACEHOLDER
ENV POLYPATH=/PLACEHOLDER
RUN apt-get install --no-install-recommends zlib1g-dev -y && rm -rf /var/lib/apt/lists/*;

#=================================
WORKDIR /polytracker/the_klondike
#PNG

RUN wget https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz
RUN tar -xvf libpng-1.6.37.tar.xz && rm libpng-1.6.37.tar.xz
WORKDIR libpng-1.6.37
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --disable-shared
RUN make -j4 install

RUN cp /usr/lib/libpng.a /usr/lib/x86_64-linux-gnu/

# Note, the /workdir directory is intended to be mounted at runtime
VOLUME ["/workdir"]
WORKDIR /workdir
