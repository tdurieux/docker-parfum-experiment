FROM python:3.8-alpine
MAINTAINER RastreatorTeam

ADD . /opt/
WORKDIR /opt/

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python","rastreator.py"]