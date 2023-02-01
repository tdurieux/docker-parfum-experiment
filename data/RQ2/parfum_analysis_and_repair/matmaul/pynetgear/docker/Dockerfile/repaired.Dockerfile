FROM python:alpine3.8
RUN pip3 install --no-cache-dir pynetgear
ENTRYPOINT [ "python", "-m",  "pynetgear" ]
