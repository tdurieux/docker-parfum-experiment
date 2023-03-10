From tier/grouper:latest

RUN yum makecache

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV PATH=/opt/grouper/grouper.apiBinary/bin:$PATH

RUN sed -i '1s:^:export GROUPER_HOME=/opt/grouper/grouper.apiBinary\n:' /opt/grouper/grouper.apiBinary/bin/gsh
RUN sed -i '1s:^:export GROUPER_HOME=/opt/grouper/grouper.apiBinary\n:' /opt/grouper/grouper.apiBinary/bin/gsh.sh

RUN sed -i '1i#!/bin/bash' /opt/grouper/grouper.apiBinary/bin/gsh
RUN sed -i '1i#!/bin/bash' /opt/grouper/grouper.apiBinary/bin/gsh.sh

RUN yum install -y openldap-clients && rm -rf /var/cache/yum

# Opensource mysql (for mysql client)
RUN yum install -y mariadb && rm -rf /var/cache/yum

COPY henplus-install /henplus

COPY /grouper-config-50.d/ /grouper-config-50.d

ENV PATH=/scripts:$PATH

RUN cd / && ln -s /opt/grouper/grouper.apiBinary/bin/gsh /bin

COPY container-files/install-grouper-configs /
CMD /install-grouper-configs && /scripts/run-grouper-loader

