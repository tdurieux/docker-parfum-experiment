FROM quay.io/gravitational/debian-tall

COPY ./start.sh /opt/
COPY ./init.sh /opt/
COPY ./update-agent.sh /opt/
RUN mkdir /opt/gravity
COPY ./gravity /opt/gravity/gravity
