ARG swift_version=5.2
ARG ubuntu_version=bionic
ARG base_image=swift:$swift_version-$ubuntu_version
FROM $base_image
# needed to do again after FROM due to docker limitation
ARG swift_version
ARG ubuntu_version

# set as UTF-8
RUN apt-get update && apt-get install --no-install-recommends -y locales locales-all && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# dependencies
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y lsof dnsutils netcat-openbsd net-tools curl jq && rm -rf /var/lib/apt/lists/*;

# ruby for generating linux tests
RUN apt-get update && apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;

# tools
RUN mkdir -p $HOME/.tools
RUN echo 'export PATH="$HOME/.tools:$PATH"' >> $HOME/.profile

# swiftformat (until part of the toolchain)

ARG swiftformat_version=0.48.11
RUN git clone --branch $swiftformat_version --depth 1 https://github.com/nicklockwood/SwiftFormat $HOME/.tools/swift-format
RUN cd $HOME/.tools/swift-format && swift build -c release
RUN ln -s $HOME/.tools/swift-format/.build/release/swiftformat $HOME/.tools/swiftformat
