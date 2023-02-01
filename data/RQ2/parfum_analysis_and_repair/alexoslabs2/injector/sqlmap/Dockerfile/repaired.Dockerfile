FROM alpine:latest

MAINTAINER Alexos Core Labs <alexoslabs@gmail.com>

RUN apk add --no-cache --update python3 git

RUN git clone https://github.com/sqlmapproject/sqlmap.git

WORKDIR /sqlmap

ENTRYPOINT ["python3", "sqlmap.py"]
