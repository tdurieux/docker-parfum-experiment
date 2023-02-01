FROM ubuntu
MAINTAINER Hui XA Chen <hchenxa@cn.ibm.com>
MAINTAINER Yong Feng <yongfeng@ca.ibm.com>

RUN apt-get update && apt-get install --no-install-recommends gettext rpm wget -y && rm -rf /var/lib/apt/lists/*;

ENV CLUSTERADMIN root
ENV CLUSTERNAME mesos
ENV BASEPORT 7869
ENV SIMPLIFIEDWEM N

RUN mkdir -p /opt/ibm/
COPY ./files/* /opt/ibm/

RUN /opt/ibm/pssasetup2015_linux-x86_64.bin --quiet
RUN rm -rf /opt/ibm/pssasetup2015_linux-x86_64.bin


VOLUME ["/opt/ibm/platform/3.3/linux-x86_64/lib/"]

ENTRYPOINT ["/opt/ibm/bootstrap.sh"]
