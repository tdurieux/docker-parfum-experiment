FROM debian:stretch
MAINTAINER Justin Wong <yuzhi.wang@tuna.tsinghua.edu.cn>

RUN apt-get update && \
	apt-get install --no-install-recommends -y git rsync awscli stunnel4 socat && \
	apt-get clean all && rm -rf /var/lib/apt/lists/*;

RUN git clone https://ftp-master.debian.org/git/archvsync.git/ /ftpsync/
WORKDIR /ftpsync/
ENV PATH /ftpsync/bin:${PATH}
CMD /bin/bash

