FROM python:3-alpine as builder
RUN mkdir -p '/opt/freenom_dns_updater'
COPY . /opt/freenom_dns_updater/
WORKDIR /opt/freenom_dns_updater
RUN python3 -m pip install --no-cache-dir .
RUN rm -rf /opt/freenom_dns_updater

FROM python:3-alpine
LABEL maintainer="github.com/maxisoft" name="freenom-dns-updater" description="A tool written in python to update freenom's dns records" url="https://github.com/maxisoft/Freenom-dns-updater" vcs-url="https://github.com/maxisoft/Freenom-dns-updater" 
RUN apk add --no-cache zlib openssl-dev binutils
COPY --from=builder / /
ENTRYPOINT [ "fdu" ]
CMD [ "process", "-i", "-c", "-r", "-t", "3600", "/etc/freenom.yml" ]
