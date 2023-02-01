FROM golang:1.10


RUN apt-get update \
	&& apt-get install --no-install-recommends -y autoconf automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential checkinstall && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libreadline-gplv2-dev libncursesw5-dev libssl-dev \
        libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
RUN tar xzf Python-3.7.0.tgz && rm Python-3.7.0.tgz
WORKDIR /usr/src/Python-3.7.0
RUN ls
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make altinstall
RUN pip3.7 install pipenv
