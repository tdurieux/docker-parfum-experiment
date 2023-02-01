# Base Distro Arg
ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG DIRSEARCH_DOWNLOAD_URL

# Content
WORKDIR /dirsearch
ADD $DIRSEARCH_DOWNLOAD_URL dirsearch.tar.gz
RUN apk --no-cache --virtual .build-deps add \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    && tar -xvf dirsearch.tar.gz -C /dirsearch --strip-components=1 \
    && pip3 install --no-cache-dir -r requirements.txt \
    && apk del .build-deps && rm dirsearch.tar.gz
ENTRYPOINT ["python3", "/dirsearch/dirsearch.py"]