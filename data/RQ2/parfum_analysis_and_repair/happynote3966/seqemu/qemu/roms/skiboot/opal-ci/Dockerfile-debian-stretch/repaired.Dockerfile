FROM debian:stretch
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y gcc-powerpc64le-linux-gnu gcc ccache expect libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget xterm curl device-tree-compiler && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-arm-linux-gnueabi && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtcl8.6 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O http://public.dhe.ibm.com/software/server/powerfuncsim/p9/packages/v1.0-0/systemsim-p9-1.0-0-trusty_amd64.deb
RUN dpkg -i systemsim-p9-1.0-0-trusty_amd64.deb
RUN apt-get -y --no-install-recommends install eatmydata && rm -rf /var/lib/apt/lists/*;
RUN eatmydata apt-get -y install build-essential gcc python g++ pkg-config libz-dev libglib2.0-dev libpixman-1-dev libfdt-dev git libstdc++6 valgrind
COPY . /build/
WORKDIR /build
ENTRYPOINT ./opal-ci/build-ubuntu-16.04.sh
