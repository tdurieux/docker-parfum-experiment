FROM ubuntu:18.04
MAINTAINER ntop.org

RUN apt-get update && \
    apt-get -y -q install wget lsb-release gnupg && \
    wget -q http://apt-stable.ntop.org/16.04/all/apt-ntop-stable.deb && \
    dpkg -i apt-ntop-stable.deb && \
    apt-get clean all

RUN apt-get update && \
    apt-get -y install nscrub 

RUN echo '#!/bin/bash\nnscrub "$@"' > /run.sh && \
    chmod +x /run.sh

EXPOSE 8880

ENTRYPOINT ["/run.sh"]
