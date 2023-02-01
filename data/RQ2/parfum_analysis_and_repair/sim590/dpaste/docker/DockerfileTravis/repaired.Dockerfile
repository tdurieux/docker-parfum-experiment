FROM sim590/dpaste-ci
MAINTAINER Simon Désaulniers <sim.desaulniers@gmail.com>
COPY . /root/dpaste
RUN cd /root/dpaste && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j8 && make install

#  vim: set ft=dockerfile ts=4 sw=4 tw=120 et :

