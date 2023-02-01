FROM python:3.8-slim

ENV PIP_VERSION 20.3.3

RUN pip install --no-cache-dir -U pip==${PIP_VERSION}

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY satellite satellite
COPY app.py ./

EXPOSE 8089 9098 9099

VOLUME /data

ENV SATELLITE_DIR=/data
ENV SATELLITE_API_PORT=8089
ENV SATELLITE_REVERSE_PROXY_PORT=9098
ENV SATELLITE_FORWARD_PROXY_PORT=9099

ENTRYPOINT ["python", "app.py"]
