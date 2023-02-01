FROM python:3.10

VOLUME /opt/c-beamd

ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir --upgrade -r /requirements.txt

EXPOSE 8000
ENTRYPOINT ["/opt/c-beamd/start"]



