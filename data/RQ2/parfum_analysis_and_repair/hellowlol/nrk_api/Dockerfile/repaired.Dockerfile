FROM alpine:3.5

RUN apk update \
    && apk add --no-cache git python py-pip ffmpeg \
    && git clone https://github.com/Hellowlol/nrkdl.git && cd nrkdl \
    && pip install --no-cache-dir -r requirements.txt

WORKDIR /nrkdl
ENTRYPOINT ["/usr/bin/python", "nrkdl.py"]
