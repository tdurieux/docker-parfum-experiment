FROM alpine:3.15
LABEL maintainer="dev@kloeckner-i.com"

ENV USER_UID=1001
ENV USER_NAME=db-operator

COPY ./db-operator /usr/local/bin/db-operator
COPY ./build/bin /usr/local/bin
RUN /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]
USER ${USER_UID}