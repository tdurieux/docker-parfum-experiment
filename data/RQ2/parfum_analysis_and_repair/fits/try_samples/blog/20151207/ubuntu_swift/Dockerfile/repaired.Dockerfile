FROM ubuntu:15.10

ENV SWIFT_PACKAGE swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu15.10

RUN apt-get update && apt-get -y --no-install-recommends install curl clang libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade



RUN curl -f https://swift.org/builds/ubuntu1510/swift-2.2-SNAPSHOT-2015-12-01-b/$SWIFT_PACKAGE.tar.gz -o $SWIFT_PACKAGE.tar.gz

RUN tar zxf $SWIFT_PACKAGE.tar.gz && rm $SWIFT_PACKAGE.tar.gz
RUN rm -f $SWIFT_PACKAGE.tar.gz

RUN apt-get clean

ENV PATH /$SWIFT_PACKAGE/usr/bin:$PATH
