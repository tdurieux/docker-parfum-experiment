FROM python:3.9.7

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git curl python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
COPY requirements.txt /requirements.txt
RUN cd /
RUN pip3 install --no-cache-dir -U -r requirements.txt
RUN mkdir /MusicPlayer
WORKDIR /MusicPlayer
COPY start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
