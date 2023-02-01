FROM alpine:3.6

RUN apk add --no-cache py2-pip py2-yaml py2-cryptography gcc python2-dev musl-dev g++
RUN pip install coverage pyyaml

RUN adduser -S tester

COPY . /infraboxcli
RUN chown -R tester /infraboxcli

WORKDIR /infraboxcli

RUN pip install .
RUN dos2unix /infraboxcli/infrabox/infraboxcli/entrypoint.sh

USER tester

CMD /infraboxcli/infrabox/infraboxcli/entrypoint.sh
