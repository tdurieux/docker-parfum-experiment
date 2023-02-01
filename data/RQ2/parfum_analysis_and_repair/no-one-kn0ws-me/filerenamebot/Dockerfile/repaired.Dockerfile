FROM ubuntu:20.04


RUN mkdir ./app
RUN chmod 777 ./app
WORKDIR ./app

RUN apt -qq update && apt -qq --no-install-recommends install -y git python3 ffmpeg python3-pip && rm -rf /var/lib/apt/lists/*; ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata



COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
