FROM python:3.6-alpine
MAINTAINER rik@vanachterberg.eu

COPY raffler.hy /tmp/
RUN pip install --no-cache-dir hy==0.13.0

ENTRYPOINT ["/tmp/raffler.hy", "/var/names.txt"]
