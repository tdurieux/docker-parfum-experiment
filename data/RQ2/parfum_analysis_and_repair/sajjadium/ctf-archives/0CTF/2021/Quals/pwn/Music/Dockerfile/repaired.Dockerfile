FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y xinetd socat busybox git build-essential && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/TeX-Live/texlive-source.git

COPY ./diff texlive-source/utils/m-tx/

RUN cd texlive-source/utils/m-tx/ && git apply diff && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

RUN cp texlive-source/utils/m-tx/prepmx /chall

WORKDIR /tmp

CMD ["/usr/sbin/xinetd", "-dontfork"]
