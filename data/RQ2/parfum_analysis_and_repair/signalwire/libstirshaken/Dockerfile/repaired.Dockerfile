FROM signalwire/freeswitch-public-base
RUN apt-get update && apt-get install --no-install-recommends -y clang-tools-7 automake autoconf libtool libcurl4-openssl-dev libjwt-dev libks && rm -rf /var/lib/apt/lists/*;
COPY . /usr/local/src/libstirshaken
WORKDIR /usr/local/src/libstirshaken

