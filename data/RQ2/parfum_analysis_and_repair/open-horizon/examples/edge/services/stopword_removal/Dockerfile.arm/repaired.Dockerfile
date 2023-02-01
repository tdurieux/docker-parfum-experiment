FROM arm32v7/python:2.7-alpine3.9

RUN apk update && apk add --no-cache jq curl

COPY *.py /

WORKDIR /
ENTRYPOINT ["/usr/local/bin/python", "stopwordremoval.py"]
