ARG pyinstaller_version=5.1

FROM minidocks/python:3-build AS build

ARG pyinstaller_version

RUN apk add --no-cache zlib-dev \
    && wget -O /tmp/pyinstaller.tar.gz "https://github.com/pyinstaller/pyinstaller/archive/v${pyinstaller_version}.tar.gz" && tar -xzf /tmp/pyinstaller.tar.gz -C /tmp \
    && cd /tmp/pyinstaller*/bootloader && CFLAGS="-Wno-stringop-overflow" "python3" ./waf configure --no-lsb all \
    && pip3 install --no-cache-dir --prefix="/tmp/pyinstaller" .. && rm /tmp/pyinstaller.tar.gz

FROM minidocks/python:3 AS latest
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk add --no-cache binutils py3-pycryptodome && clean

COPY --from=build /tmp/pyinstaller/ /usr/
COPY rootfs /

CMD [ "pyinstaller" ]
