FROM registry.ci.openshift.org/ocp/4.12:must-gather
COPY must-gather/* /usr/bin/
RUN chmod +x /usr/bin/gather

ENTRYPOINT /usr/bin/gather