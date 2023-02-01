FROM golang

RUN go get golang.org/x/tools/cmd/cover

RUN sed -i -e 's/httpredir.debian.org/ftp.us.debian.org/' /etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install fakeroot && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install rpm && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/hogliux/bomutils/tarball/master | tar xz && cd hogliux-bomutils-* && make install

RUN apt-get update && apt-get -y --no-install-recommends install libxml2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz | tar xz && cd xar* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

RUN apt-get update && apt-get -y --no-install-recommends install cpio && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli

RUN apt-get update && apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;

# for debian repository generation
RUN apt-get update && apt-get -y --no-install-recommends install ruby1.9.1 && rm -rf /var/lib/apt/lists/*;
RUN gem install deb-s3
RUN apt-get update && apt-get -y --no-install-recommends install createrepo && rm -rf /var/lib/apt/lists/*;

# for rpmsigning process
RUN apt-get update && apt-get -y --no-install-recommends install expect && rm -rf /var/lib/apt/lists/*;

# osslsigncode
RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
    autoconf \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && \
  curl -f -L https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz | \
    tar xzf - && \
  cd osslsigncode-1.7.1 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make && \
  make install && \
  cd .. && \
  rm -rf osslsigncode-1.7.1
