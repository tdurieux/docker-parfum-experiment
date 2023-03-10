# to build it:
#    sudo docker build --tag plasm5 -f Dockerfile.plasm5 .

# to run it:
#    sudo docker run plasm5

# if you need to debug:
#    sudo docker run -it --entrypoint /bin/bash plasm5
#    /opt/plasm5/bin/plasm

FROM i386/debian

RUN apt-get update && apt-get install --no-install-recommends -y wget gcc make freeglut3 freeglut3-dev libxml2 libxml2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
RUN wget https://mirror.kumi.systems/gnu/gsl/gsl-1.1.1.tar.gz
RUN tar xvzf gsl-1.1.1.tar.gz && rm gsl-1.1.1.tar.gz
RUN cd gsl-1.1.1 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

WORKDIR /tmp
RUN wget https://plasm.net/download/latest-classic-release-51/gnulinux-debian.tgz
RUN tar xvzf gnulinux-debian.tgz && rm gnulinux-debian.tgz
RUN cd plasm-5 && tar xvf plasm-bin.tar -C / && rm plasm-bin.tar

env LD_LIBRARY_PATH /usr/local/lib
env MZSCHEME /opt/plasm5
WORKDIR /opt/plasm5

CMD ["/opt/plasm5/bin/plasm"]





