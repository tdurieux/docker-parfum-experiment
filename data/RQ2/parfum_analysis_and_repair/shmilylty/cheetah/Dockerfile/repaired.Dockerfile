FROM alpine:3.9
LABEL MAINTAINER furkan.sayim@yandex.com

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add --no-cache git
RUN git clone https://github.com/sunnyelf/cheetah.git /tmp/cheetah

WORKDIR /tmp/cheetah
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "cheetah.py"]
