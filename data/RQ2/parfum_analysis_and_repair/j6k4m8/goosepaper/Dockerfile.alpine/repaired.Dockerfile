FROM alpine:3.12

LABEL maintainer="Sergio Moura <sergio@moura.ca>"

RUN apk --update --no-cache add cairo libffi libjpeg libstdc++ libxml2 libxslt pango \
py3-aiohttp py3-cffi py3-feedparser py3-gobject3 py3-html5lib py3-lxml py3-multidict \
py3-numpy py3-requests py3-yarl ttf-dejavu

# Panda
ARG PANDAS_VERSION=1.1.5
RUN apk add --no-cache --virtual .build-deps curl build-base linux-headers py3-pip py3-numpy-dev python3-dev py3-setuptools && \
 pip3 install --no-cache-dir cython && \
cd /tmp && \
 curl -f -LO https://github.com/pandas-dev/pandas/releases/download/v${PANDAS_VERSION}/pandas-${PANDAS_VERSION}.tar.gz && \
tar zxf pandas-${PANDAS_VERSION}.tar.gz && \
cd pandas-${PANDAS_VERSION} && \
python3 setup.py build && \
python3 setup.py install --prefix=/usr && \
cd /tmp && \
rm -rf pandas-${PANDAS_VERSION}.tar.gz pandas-${PANDAS_VERSION} && \
pip3 uninstall -y cython && \
apk del .build-deps && \
rm -Rf /root/.cache

WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache --virtual .build-deps build-base git libxml2-dev libxslt-dev libffi-dev libjpeg-turbo-dev py3-pip py3-wheel python3-dev && \
 pip3 install --no-cache-dir -r ./requirements.txt && \
apk del .build-deps && \
rm -Rf /root/.cache
COPY . .
RUN apk add --no-cache --virtual .install-deps py3-pip && \
 pip3 install --no-cache-dir -e . && \
apk del .install-deps && \
rm -Rf /root/.cache

ENTRYPOINT ["goosepaper"]
