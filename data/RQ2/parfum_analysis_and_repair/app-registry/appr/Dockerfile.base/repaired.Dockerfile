FROM six8/pyinstaller-alpine:apline-v3.4-pyinstaller-develop

ENV workdir /opt/appr-server
RUN mkdir -p $workdir
RUN apk --no-cache --update add python py-pip openssl ca-certificates git curl
RUN apk --no-cache --update add --virtual build-dependencies \
      python-dev build-base wget openssl-dev libffi-dev libstdc++
COPY . $workdir
WORKDIR $workdir

RUN pip install --no-cache-dir pip -U \
    && pip install --no-cache-dir -r requirements_dev.txt \
    && pip install --no-cache-dir -e .

