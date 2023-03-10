FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
ENV OPERATOR=/usr/local/bin/terraform-operator \
    USER_UID=1001 \
    USER_NAME=terraform-operator \
    HOME=/home/terraform-operator
# install operator binary
COPY _output/manager ${OPERATOR}
COPY bin /usr/local/bin
RUN  /usr/local/bin/user_setup
ENTRYPOINT ["/usr/local/bin/entrypoint"]
USER ${USER_UID}