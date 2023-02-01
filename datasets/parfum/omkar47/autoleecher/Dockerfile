FROM ubuntu:20.04
 
 
RUN mkdir ./app
RUN chmod 777 ./app
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

RUN apt -qq update

RUN apt -qq install -y git aria2 wget curl busybox unzip unrar tar python3 ffmpeg python3-pip

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .
CMD ["bash","start.sh"]
