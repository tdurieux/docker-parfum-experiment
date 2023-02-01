FROM debian:11
FROM python:3.10.1-slim-buster

WORKDIR /Emli/

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN python3.9 -m pip install -U pip
RUN apt-get install --no-install-recommends -y wget python3-pip curl bash neofetch ffmpeg software-properties-common && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .

RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir -U -r requirements.txt

COPY . .
CMD ["python3.9", "-m", "Emli"]
