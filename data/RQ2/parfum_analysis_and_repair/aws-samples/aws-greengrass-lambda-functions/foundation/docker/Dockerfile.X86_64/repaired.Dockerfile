FROM 216483018798.dkr.ecr.us-west-2.amazonaws.com/aws-iot-greengrass:1.10.1-amazonlinux-x86-64

RUN ln -sf /usr/bin/java /usr/local/bin/java8
RUN yum install -y awscli jq && rm -rf /var/cache/yum

ADD foundation/docker/redeploy.sh /

RUN yum update -y
RUN yum install -y git automake gcc-c++ libtool libtool-ltdl-devel openssl openssl-devel && rm -rf /var/cache/yum
RUN git clone https://github.com/opendnssec/SoftHSMv2.git
RUN cd SoftHSMv2 && sh autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

ADD build/oem.GROUP_NAME.tar /greengrass/

EXPOSE 8883

CMD bash ./redeploy.sh && \
    bash /greengrass-entrypoint.sh
