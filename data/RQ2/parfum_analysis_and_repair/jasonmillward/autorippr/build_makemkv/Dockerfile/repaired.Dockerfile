FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y python-virtualenv build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

ADD http://www.makemkv.com/download/makemkv-oss-1.12.3.tar.gz /src/
ADD http://www.makemkv.com/download/makemkv-bin-1.12.3.tar.gz /src/

RUN tar xf /src/makemkv-bin-1.12.3.tar.gz -C /src && rm /src/makemkv-bin-1.12.3.tar.gz


RUN mkdir /src/makemkv-bin-1.12.3/tmp/
RUN echo 'accepted' > /src/makemkv-bin-1.12.3/tmp/eula_accepted

RUN  sed -ie 's#DESTDIR=#DESTDIR=/build#g' /src/makemkv-bin-1.12.3/Makefile

RUN cd /src/makemkv-bin-1.12.3 && make install

RUN tar xf /src/makemkv-oss-1.12.3.tar.gz -C /src && rm /src/makemkv-oss-1.12.3.tar.gz

RUN cd /src/makemkv-oss-1.12.3 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /build/usr --disable-gui && make install

CMD ["tar", "cz", "/build"]
