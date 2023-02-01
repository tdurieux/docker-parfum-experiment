FROM debian:stretch
ENV DEBIAN_FRONTEND    noninteractive
RUN apt-get update -qq
RUN if [ `arch` != "ppc64le" ]; then \
 apt-get update -qq && apt-get install --no-install-recommends -y gcc-powerpc64le-linux-gnu; rm -rf /var/lib/apt/lists/*; fi
RUN apt-get update -qq && apt-get install --no-install-recommends -y gcc ccache expect libssl-dev wget xterm curl device-tree-compiler build-essential gcc python g++ pkg-config libz-dev libglib2.0-dev libpixman-1-dev libfdt-dev git libstdc++6 valgrind libtcl8.6 libmbedtls-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -qq && apt-get install --no-install-recommends -y gcc-arm-linux-gnueabi || true && rm -rf /var/lib/apt/lists/*;
RUN if [ `arch` = "x86_64" ]; then \
 curl -f -L -O http://public.dhe.ibm.com/software/server/powerfuncsim/p9/packages/v1.0-0/systemsim-p9-1.0-0-trusty_amd64.deb; dpkg -i systemsim-p9-1.0-0-trusty_amd64.deb;fi
COPY . /build/
WORKDIR /build
