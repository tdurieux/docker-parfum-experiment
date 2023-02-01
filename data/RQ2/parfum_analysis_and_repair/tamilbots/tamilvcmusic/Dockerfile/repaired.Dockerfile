FROM python:3.9.6-slim-buster
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends git curl python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN python3.9 -m pip install -U pip
COPY . /app
WORKDIR /app
RUN python3.9 -m pip install -U -r requirements.txt
CMD python3.9 -m TamilVc
