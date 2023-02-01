FROM alpine:3.12.0

RUN apk add --no-cache python3 py3-pip git
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir -e git+https://github.com/shuque/pydig.git@v1.6.3#egg=pydig

ENTRYPOINT ["/usr/bin/pydig"]
