FROM alpine
RUN apk update && apk add --no-cache py-pip gcc python-dev libc-dev
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir autotrace
ENTRYPOINT autotrace
