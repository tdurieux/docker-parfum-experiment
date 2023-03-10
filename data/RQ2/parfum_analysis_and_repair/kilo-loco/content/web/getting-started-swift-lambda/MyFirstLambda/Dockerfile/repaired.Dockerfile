FROM swiftlang/swift:nightly-5.3-amazonlinux2
 RUN yum -y install git \
 libuuid-devel \
 libicu-devel \
 libedit-devel \
 libxml2-devel \
 sqlite-devel \
 python-devel \
 ncurses-devel \
 curl-devel \
 openssl-devel \
 tzdata \
 libtool \
 jq \
 tar \
 zip && rm -rf /var/cache/yum