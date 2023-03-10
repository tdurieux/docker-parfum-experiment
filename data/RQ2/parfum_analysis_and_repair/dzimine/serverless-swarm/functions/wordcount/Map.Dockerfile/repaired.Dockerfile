FROM python:2.7-alpine

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -qr /tmp/requirements.txt
COPY ./wordcount /opt/wordcount/
WORKDIR /opt/wordcount

ENTRYPOINT ["python", "map.py"]
