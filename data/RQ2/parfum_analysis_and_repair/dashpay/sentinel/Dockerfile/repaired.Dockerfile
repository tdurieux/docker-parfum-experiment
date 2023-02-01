FROM python:3.9-slim-buster
LABEL maintainer="Dash Developers <dev@dash.org>"
LABEL description="Dockerised Sentinel"

COPY . /sentinel

RUN cd /sentinel && \
    rm sentinel.conf && \
    pip install --no-cache-dir -r requirements.txt

ENV HOME /sentinel
WORKDIR /sentinel

ADD share/run.sh /

CMD /run.sh
