# for fly debug on Ubuntu
FROM ubuntu:latest

# system basic
RUN apt update -y
RUN apt install --no-install-recommends -y build-essential m4 perl autotools-dev autoconf automake libtool-bin autoconf-archive lsof vim && rm -rf /var/lib/apt/lists/*;
# fly dependent library
RUN apt install --no-install-recommends -y libssl-dev zlib1g-dev libbrotli-dev && rm -rf /var/lib/apt/lists/*;
# python install
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /fly
RUN python3 -m pip install --upgrade pip
# copy fly project directory
COPY . .
RUN pwd
RUN ls -l
RUN python3 -m pip install -r requirements.txt
# build
RUN autoreconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cat config.h
RUN make
RUN make install
RUN python3 setup.py build
# copy extension module(fly module) from build directory to fly directory
RUN cp -rf build/lib.linux*/fly/_fly_server.cpython* fly/
# make key file
RUN openssl req \
	-subj '/CN=localhost' \
	-x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout tests/fly_test.key \
	-out tests/fly_test.crt
# python test
RUN python3 -m pytest tests
