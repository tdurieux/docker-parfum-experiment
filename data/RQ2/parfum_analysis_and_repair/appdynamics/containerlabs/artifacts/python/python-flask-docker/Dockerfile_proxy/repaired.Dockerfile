FROM python:3.6


WORKDIR /opt/appdynamics

ADD startup.sh /opt/appdynamics/startup.sh

ENTRYPOINT ["/opt/appdynamics/startup.sh"]