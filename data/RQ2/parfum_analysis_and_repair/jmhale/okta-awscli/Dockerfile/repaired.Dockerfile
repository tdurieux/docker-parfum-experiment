FROM python:3.7-alpine

WORKDIR /opt/okta-awscli

COPY . .

RUN apk --update --no-cache add gcc musl-dev libffi-dev openssl-dev \
    && pip install --no-cache-dir awscli \
    && python setup.py install \
    && apk del --purge gcc musl-dev libffi-dev openssl-dev

ENTRYPOINT ["/usr/local/bin/okta-awscli"]
