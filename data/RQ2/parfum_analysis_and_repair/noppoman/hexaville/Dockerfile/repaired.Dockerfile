FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

ENV SWIFT_VERSION="swift-5.1"
ENV SWIFT_DOWNLOAD_URL=https://swift.org/builds/${SWIFT_VERSION}-release/ubuntu1404/${SWIFT_VERSION}-RELEASE/${SWIFT_VERSION}-RELEASE-ubuntu14.04.tar.gz
ENV SWIFTFILE=${SWIFT_VERSION}-RELEASE-ubuntu14.04
ENV BUILD_CONFIGURATION=release
ENV DEST=/Hexaville/.build

RUN wget $SWIFT_DOWNLOAD_URL
RUN tar -zxf $SWIFTFILE.tar.gz && rm $SWIFTFILE.tar.gz
ENV PATH $PWD/$SWIFTFILE/usr/bin:"${PATH}"

# basic dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git build-essential software-properties-common pkg-config locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libbsd-dev uuid-dev libxml2-dev libxslt1-dev python-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev libblocksruntime0 libssl-dev && rm -rf /var/lib/apt/lists/*;

# clang
RUN apt-get update && apt-get install --no-install-recommends -y clang-3.9 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.9 100
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.9 100

RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

COPY . Hexaville

WORKDIR Hexaville

RUN mkdir -p .build/release

CMD ["/bin/bash", "./Scripts/zip.sh"]
