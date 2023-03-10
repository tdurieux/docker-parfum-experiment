FROM alpine:3.10.0

COPY test/httpecho.py /

RUN apk --no-cache add python3 

ENTRYPOINT [ "/usr/bin/python3", "/httpecho.py" ]