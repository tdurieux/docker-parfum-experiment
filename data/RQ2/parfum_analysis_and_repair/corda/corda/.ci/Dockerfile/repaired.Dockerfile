FROM amazoncorretto:8u242
RUN yum install -y shadow-utils && rm -rf /var/cache/yum
RUN useradd -m buildUser