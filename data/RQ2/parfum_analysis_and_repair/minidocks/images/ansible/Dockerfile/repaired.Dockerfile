FROM minidocks/python
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

ARG version=5.6.0

RUN apk add --no-cache py3-crypto py3-paramiko py3-yaml py3-jinja2 py3-markupsafe py3-ruamel.yaml \
    && pip install --no-cache-dir ansible==$version ansible-lint[yamllint] virtualenv docker \
    && clean

COPY rootfs /

CMD [ "ansible" ]
