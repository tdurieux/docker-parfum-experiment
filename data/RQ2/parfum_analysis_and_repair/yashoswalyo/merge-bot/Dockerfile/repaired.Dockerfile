FROM ubuntu:latest

WORKDIR /usr/src/mergebot
RUN chmod 777 /usr/src/mergebot

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y python3 python3-pip \
    p7zip-full p7zip-rar xz-utils wget curl pv jq \
    ffmpeg unzip neofetch mediainfo && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://rclone.org/install.sh | bash

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x start.sh

CMD ["bash","start.sh"]
