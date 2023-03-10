FROM python:3.8-alpine3.10

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

COPY . /aiomsg

RUN pip install --no-cache-dir -e aiomsg[test]
WORKDIR /aiomsg
CMD ["python", "-m", "pytest", "--cov", "aiomsg", "--cov-report", "term-missing"]
