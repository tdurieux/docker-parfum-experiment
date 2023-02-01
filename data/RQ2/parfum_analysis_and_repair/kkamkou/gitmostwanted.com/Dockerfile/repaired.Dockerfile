FROM python:latest

RUN groupadd -r gitmostwanted \
  && useradd -r -g gitmostwanted gitmostwanted \
  && mkdir /opt/gitmostwanted

WORKDIR /opt/gitmostwanted

VOLUME ["/opt/gitmostwanted"]

ADD requirements.txt ./

ENV PYTHONPATH /opt/gitmostwanted

RUN pip install --no-cache-dir -U pip \
  && pip install --no-cache-dir -r requirements.txt
