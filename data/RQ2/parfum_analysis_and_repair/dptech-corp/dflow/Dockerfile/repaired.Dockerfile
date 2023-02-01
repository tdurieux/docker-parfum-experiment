FROM python:3.8

WORKDIR /data/dflow
ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY ./ ./
RUN pip install --no-cache-dir .

