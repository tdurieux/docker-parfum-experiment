FROM alpine
RUN apk update && apk add --no-cache python3 && apk add --no-cache py3-dnspython
COPY test-dns.py /
ENTRYPOINT ["python3","/test-dns.py"]
