FROM alpine:3

RUN apk update && \
    apk add --no-cache ca-certificates python-dev py-setuptools wget && \
    easy_install-2.7 pip && \
    pip install --no-cache-dir pyyaml==3.12 kubernetes

ADD launcher /launcher

ENTRYPOINT ["python", "/launcher/launch_sparkapplication.py"]
