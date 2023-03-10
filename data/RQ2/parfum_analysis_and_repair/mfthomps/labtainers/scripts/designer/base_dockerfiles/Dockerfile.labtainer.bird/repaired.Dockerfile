ARG registry
FROM $registry/labtainer.network
LABEL description="This is base Docker image for Labtainer Bird router containers"
# restore original sources
RUN mv /var/tmp/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y flex bison libncurses5-dev libreadline6 libreadline6-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /bird
ADD zip/bird-2.0.7.tar.gz /bird
ADD zip/bird-doc-2.0.7.tar.gz /bird
ADD system/etc/systemd/system/bird.service /etc/systemd/system/
WORKDIR /bird/bird-2.0.7
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
# fix broken bird makefile
RUN sed '/^git-label/d' -i Makefile
RUN make
RUN make install
RUN systemctl enable bird.service
