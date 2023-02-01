FROM python:3.7-slim-buster

RUN apt update && apt install --no-install-recommends -y libsndfile1-dev wget ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

WORKDIR /app/src
COPY requirements.txt /app/requirements.txt

RUN pip3 install --no-cache-dir -r /app/requirements.txt

RUN mkdir -p /tmp/audio-data

COPY . /app

CMD python3 main.py
