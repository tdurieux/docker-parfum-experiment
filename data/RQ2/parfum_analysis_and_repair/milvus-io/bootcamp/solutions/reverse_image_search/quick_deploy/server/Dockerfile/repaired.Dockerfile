FROM python:3.7-slim-buster

RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/src
COPY . /app

RUN pip3 install --no-cache-dir -r /app/requirements.txt

CMD python3 main.py
