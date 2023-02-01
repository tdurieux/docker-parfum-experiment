FROM	ubuntu:rolling

ENV		DEBIAN_FRONTEND noninteractive

RUN apt-get update ; \
		apt-get install --no-install-recommends -y apt-utils joe sudo; rm -rf /var/lib/apt/lists/*; \
		apt-get install --no-install-recommends -y bison clang cmake flex g++ git; \
		apt-get install --no-install-recommends -y libboost-all-dev libeigen3-dev libgmp-dev; \
		useradd -m -s /bin/bash user && echo "user ALL= NOPASSWD: ALL\n" >> /etc/sudoers

COPY	. carl/

RUN		cd carl/ &&\
		mkdir -p build/ &&\
		ls &&\
		cd build/ &&\
		cmake -DUSE_COCOA=ON ../ &&\
		make &&\
		make test
