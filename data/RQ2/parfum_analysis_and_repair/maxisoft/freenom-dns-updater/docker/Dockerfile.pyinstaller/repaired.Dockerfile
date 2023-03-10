FROM python:3-alpine as builder
RUN apk add --no-cache build-base wget unzip python3-dev openssl-dev alpine-sdk zlib-dev git
RUN apk add --no-cache upx || :
RUN mkdir -p '/opt/freenom_dns_updater'
COPY . /opt/freenom_dns_updater
WORKDIR /opt/freenom_dns_updater
RUN python3 -m pip install --no-cache-dir .
# Compile and install pyinstaller
RUN git clone https://github.com/pyinstaller/pyinstaller.git --branch master
RUN cd pyinstaller/bootloader && python ./waf distclean all
RUN cd pyinstaller && python setup.py install
# Build the executable
RUN python3 -m pip uninstall -y freenom-dns-updater
RUN python3 -O -m PyInstaller -y --clean --strip --console freenom_dns_updater/scripts/fdu.py
RUN ls -lah dist/fdu


FROM alpine
LABEL maintainer="github.com/maxisoft" name="freenom-dns-updater" description="A tool written in python to update freenom's dns records" url="https://github.com/maxisoft/Freenom-dns-updater" vcs-url="https://github.com/maxisoft/Freenom-dns-updater"
RUN apk add --no-cache zlib openssl-dev binutils
COPY --from=builder /opt/freenom_dns_updater/dist/fdu /opt/freenom_dns_updater
ENTRYPOINT [ "/opt/freenom_dns_updater/fdu" ]
CMD [ "process", "-i", "-c", "-r", "-t", "3600", "/etc/freenom.yml" ]
