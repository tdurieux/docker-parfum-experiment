FROM alpine

RUN apk --update --no-cache add python3 py3-pip py3-openssl py3-cryptography py3-requests tzdata && \
    pip3 install --no-cache-dir --upgrade pip && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone

COPY requirements.txt /opt/fandogh_cli/requirements.txt
RUN pip3 install --no-cache-dir -r /opt/fandogh_cli/requirements.txt

ENV COLLECT_ERROR True
WORKDIR /opt/fandogh_cli
COPY . /opt/fandogh_cli

RUN python3 setup.py install
CMD ["fandogh"]