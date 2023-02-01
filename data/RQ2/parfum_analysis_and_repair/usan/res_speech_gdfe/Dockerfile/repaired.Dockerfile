FROM centos:7
WORKDIR /tmp

ADD http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13.21.0.tar.gz .

RUN tar xvfz asterisk-13.21.0.tar.gz && rm asterisk-13.21.0.tar.gz

WORKDIR /tmp/asterisk-13.21.0

RUN contrib/scripts/install_prereq install

COPY res_speech_gdfe.cc res/res_speech_gdfe.cc

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-pjproject-bundled && make



