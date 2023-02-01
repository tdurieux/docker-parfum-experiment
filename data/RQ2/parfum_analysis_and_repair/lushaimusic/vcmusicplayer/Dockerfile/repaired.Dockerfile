FROM debian:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git curl python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm i -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt /requirements.txt
RUN cd /
RUN pip3 install --no-cache-dir -U -r requirements.txt
RUN mkdir /MusicPlayer
WORKDIR /MusicPlayer
COPY start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
