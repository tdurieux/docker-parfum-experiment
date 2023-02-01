FROM python:3.8-alpine AS installer
#Layer Code
COPY extensionssrc /opt/
COPY extensionssrc/requirements.txt /opt/
RUN pip install --no-cache-dir -r /opt/requirements.txt -t /opt/extensions/lib
WORKDIR /opt/extensions
RUN chmod -R 755 *.py

FROM scratch AS base
WORKDIR /opt/extensions
COPY --from=installer /opt/extensions .
