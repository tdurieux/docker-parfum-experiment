FROM python:3.5.6-alpine
LABEL maintainer="yann.foelling@koeln.de"

RUN mkdir -p /opt/yair/

COPY requirements.txt /opt/yair/
COPY yair.py /opt/yair/yair.py

RUN pip install --no-cache-dir -r /opt/yair/requirements.txt

ENTRYPOINT ["/opt/yair/yair.py"]
CMD ""
