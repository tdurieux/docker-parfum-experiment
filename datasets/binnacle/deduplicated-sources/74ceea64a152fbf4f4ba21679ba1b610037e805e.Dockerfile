FROM alpine:3.6

RUN apk add --no-cache python3 py3-cryptography gcc python3-dev musl-dev g++
RUN pip3 install coverage pyyaml

RUN adduser -S tester

COPY . /infraboxcli
RUN chown -R tester /infraboxcli

WORKDIR /infraboxcli

RUN pip3 install .

USER tester

RUN dos2unix /infraboxcli/infrabox/infraboxcli/entrypoint.sh

CMD /infraboxcli/infrabox/infraboxcli/entrypoint.sh
