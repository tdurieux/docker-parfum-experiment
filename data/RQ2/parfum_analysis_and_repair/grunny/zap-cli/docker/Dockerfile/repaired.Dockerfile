FROM python:alpine
LABEL maintainer="mwgrunny@gmail.com"
ARG VERSION=0.10.0
RUN pip install --no-cache-dir zapcli==$VERSION

ENTRYPOINT [ "zap-cli" ]
