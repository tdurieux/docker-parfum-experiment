FROM ubuntu:16.04
COPY deploy/provision.sh /opt/provision.sh
RUN sh /opt/provision.sh

COPY deploy/build-env.sh /opt/build-env.sh
CMD ["sh", "/opt/build-env.sh", "/opt/apps/tracker/"]