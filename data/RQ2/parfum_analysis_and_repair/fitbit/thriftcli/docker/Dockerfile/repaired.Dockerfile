FROM python:2.7

RUN pip install --no-cache-dir thriftcli==1.5

ENTRYPOINT [ "thriftcli" ]
