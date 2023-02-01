FROM oraclelinux:7-slim
LABEL maintainer="Xinnong Wang <xinnong.wang@oracle.com>"
RUN curl -f -s https://bootstrap.pypa.io/get-pip.py | python - && \
 pip install --no-cache-dir mkdocs
