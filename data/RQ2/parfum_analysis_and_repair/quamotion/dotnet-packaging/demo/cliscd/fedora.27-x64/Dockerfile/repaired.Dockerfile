FROM fedora:27

ENV rid=fedora.27-x64

COPY cliscd.1.0.0.$rid.rpm /pkg/
COPY reference.txt /pkg/

RUN yum update -y \
&& yum install -y /pkg/cliscd.1.0.0.$rid.rpm && rm -rf /var/cache/yum

RUN ls -a /usr/share/cliscd >> ~/testoutput.log 2>&1 || exit 0
RUN ls -a /etc/cliscd >> ~/testoutput.log 2>&1 || exit 0
RUN ls -a ~/.cliscd >> ~/testoutput.log 2>&1 || exit 0

RUN diff -w /pkg/reference.txt ~/testoutput.log

CMD [ "/usr/share/cliscd/cliscd" ]
