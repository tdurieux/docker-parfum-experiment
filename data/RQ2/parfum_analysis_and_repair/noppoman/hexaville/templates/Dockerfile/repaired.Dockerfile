FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

ENV DEST={{DEST}}
ENV EXECUTABLE_NAME={{EXECUTABLE_NAME}}
ENV SWIFT_DOWNLOAD_URL={{SWIFT_DOWNLOAD_URL}}
ENV SWIFTFILE={{SWIFTFILE}}

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

COPY . hexaville-app

WORKDIR hexaville-app

CMD ["/bin/bash", "./build-swift.sh"]
