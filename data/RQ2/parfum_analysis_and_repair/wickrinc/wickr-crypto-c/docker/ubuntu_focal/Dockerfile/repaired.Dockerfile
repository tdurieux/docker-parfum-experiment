FROM ubuntu:20.04

ADD . /usr/share/wickr-crypto-c
WORKDIR /usr/share/wickr-crypto-c

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y --no-install-recommends -qq install nodejs curl git build-essential autoconf automake cmake bison libpcre3-dev > /dev/null && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/yegorich/swig.git && cd swig && git checkout 0ea6a3bdbf3184d230bf17d2c17704dbc2ec7aac && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

RUN node -v
RUN npm -v
