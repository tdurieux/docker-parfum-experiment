FROM python:2.7-alpine

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -qr /tmp/requirements.txt
COPY ./encode /opt/encode/
WORKDIR /opt/encode

ENTRYPOINT ["python", "main.py"]
