FROM python:3-slim-buster

COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY exporter.py /usr/local/bin/homematic_exporter

ENTRYPOINT [ "/usr/local/bin/homematic_exporter" ]

EXPOSE 8010
