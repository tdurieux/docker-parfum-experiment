FROM ubuntu:trusty
MAINTAINER Zi Shen Lim <zlim.lnx@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb [trusted=yes] http://repo.iovisor.org/apt/trusty trusty-nightly main" > /etc/apt/sources.list.d/iovisor.list
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y libelf1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bcc-tools libbcc-examples && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
