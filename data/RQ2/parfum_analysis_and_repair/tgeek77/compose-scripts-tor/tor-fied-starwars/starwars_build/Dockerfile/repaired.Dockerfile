FROM alpine
MAINTAINER Rohan Singh "rohan@washington.edu"

RUN apk update && apk add --no-cache python

ADD ascii-telnet-server.py /root/
ADD sw1.txt /root/

EXPOSE 23

ENTRYPOINT ["python", "/root/ascii-telnet-server.py"]
CMD ["-f", "/root/sw1.txt"]
