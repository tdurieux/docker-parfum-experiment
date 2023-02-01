FROM python:2.7.17-alpine3.10

RUN apk update \
    && apk add --no-cache git curl libxml2-dev libxslt-dev build-base \
    && git clone https://github.com/nettitude/Prowl.git \
    && cd  /Prowl \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir requests bs4 \
    && mkdir Output

WORKDIR /Prowl

VOLUME [ "/Prowl/Output" ]

ENTRYPOINT ["python", "prowl.py"]
CMD ["-h"]
