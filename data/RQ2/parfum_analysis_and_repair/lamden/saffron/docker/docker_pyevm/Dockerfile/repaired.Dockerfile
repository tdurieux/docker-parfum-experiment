FROM alpine

COPY gevent-1.2.1-cp27-cp27mu-linux_x86_64.whl /root/gevent-1.2.1-cp27-cp27mu-linux_x86_64.whl
COPY lxml-3.4.0-cp27-cp27mu-linux_x86_64.whl /root/lxml-3.4.0-cp27-cp27mu-linux_x86_64.whl

RUN apk update \
    && apk add --no-cache libtool libevent-dev make xz libstdc++ libffi-dev libressl-dev postgresql-dev musl-dev gcc python-dev libxslt pcre libxml2-dev python py-pip ca-certificates py-setuptools \
    && pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir /root/gevent-1.2.1-cp27-cp27mu-linux_x86_64.whl
RUN pip install --no-cache-dir /root/lxml-3.4.0-cp27-cp27mu-linux_x86_64.whl

COPY py-evm/dist/py-evm-0.2.0a1.tar.gz /root/py-evm-0.2.0a1.tar.gz
RUN pip install --no-cache-dir /root/py-evm-0.2.0a1.tar.gz
