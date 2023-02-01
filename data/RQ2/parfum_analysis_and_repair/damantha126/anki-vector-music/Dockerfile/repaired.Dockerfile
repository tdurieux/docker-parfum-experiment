FROM debian:latest
FROM python:3.9.6-slim-buster
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git curl python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 -m AnkiVectorMusic
