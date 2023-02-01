FROM mirceaulinic/salt-sproxy

MAINTAINER ping@mirceaulinic.net

COPY ./roster /etc/salt/roster
# direct copy reduces image size
COPY --from=napalmautomation/napalm:develop /usr/local/lib/python3.6/site-packages /usr/local/lib/python3.6/site-packages
COPY --from=napalmautomation/napalm:develop /usr/local/bin/napalm /usr/local/bin/napalm

RUN pip --no-cache-dir install ciscoconfparse==1.3.39 jxmlease==1.0.1 scp==0.13.2 ansible==2.8.1 pynetbox==4.0.6