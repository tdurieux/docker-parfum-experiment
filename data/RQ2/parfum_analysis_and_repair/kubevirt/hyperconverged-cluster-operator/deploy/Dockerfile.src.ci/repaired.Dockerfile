FROM src

RUN yum install -y expect && rm -rf /var/cache/yum
COPY oc /usr/bin/oc
