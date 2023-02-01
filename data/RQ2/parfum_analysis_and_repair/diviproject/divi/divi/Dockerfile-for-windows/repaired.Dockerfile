FROM ubuntu:bionic

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends apt-utils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends bsdmainutils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:bitcoin/bitcoin -y

RUN apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends pkg-config -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends autoconf -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libtool -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libboost-all-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libssl1.0-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libevent-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libdb4.8-dev libdb4.8++-dev -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential autotools-dev automake bsdmainutils curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6 libc6-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . .

RUN apt-get install --no-install-recommends -y g++-mingw-w64-x86-64 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

# Comment out the next three lines if you're not interested in building the dependencies
WORKDIR /app/depends
RUN make HOST=x86_64-w64-mingw32

WORKDIR /app/src/GMock
RUN autoreconf -fvi

WORKDIR /app
RUN PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')
RUN ./autogen.sh
RUN CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-tests --without-gui --prefix=/
RUN make

CMD ["bash"]
