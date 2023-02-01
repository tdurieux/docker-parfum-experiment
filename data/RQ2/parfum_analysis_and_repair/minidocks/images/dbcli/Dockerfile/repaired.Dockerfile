ARG mycli_version=1.24.3
ARG pgcli_version=3.3.1
ARG litecli_version=1.7.0
ARG iredis_version=1.11.0

FROM minidocks/python AS mycli
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

ARG mycli_version

RUN apk --update --no-cache add py3-cryptography && pip install --no-cache-dir mycli==$mycli_version && clean

COPY rootfs /

CMD [ "mycli" ]

FROM minidocks/python AS pgcli

ARG pgcli_version

RUN apk --update --no-cache add py3-psutil py3-psycopg2 py3-setproctitle && pip install --no-cache-dir pg_activity pgcli==$pgcli_version && clean

COPY rootfs /

CMD [ "pgcli" ]

FROM minidocks/python AS litecli

ARG litecli_version

RUN pip install --no-cache-dir litecli==$litecli_version && clean

COPY rootfs /

CMD [ "litecli" ]

FROM minidocks/python AS iredis

ARG iredis_version

RUN pip install --no-cache-dir iredis==$iredis_version && clean

COPY rootfs /

CMD [ "iredis" ]

FROM minidocks/python AS latest

ARG mycli_version
ARG pgcli_version
ARG litecli_version
ARG iredis_version

RUN apk --update --no-cache add py3-cryptography py3-psutil py3-psycopg2 py3-setproctitle \
    && pip install --no-cache-dir pg_activity pgcli==$pgcli_version mycli==$mycli_version litecli==$litecli_version iredis==$iredis_version && clean

COPY rootfs /
