FROM python:3.7-alpine

RUN apk update \
    && apk add --no-cache git curl libxml2-dev libxslt-dev build-base \
    && git clone https://github.com/m8r0wn/CrossLinked.git \
    && cd  /CrossLinked \
    && pip3 install --no-cache-dir -r requirements.txt \
    && pip3 install --no-cache-dir requests bs4 \
    && mkdir Output

WORKDIR /CrossLinked

VOLUME [ "/output" ]

ENTRYPOINT ["python3", "crosslinked.py"]
CMD ["-h"]
