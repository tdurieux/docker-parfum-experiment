FROM debian:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN apt -qq install -y --no-install-recommends megatools && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN mkdir /app/
WORKDIR /app/
RUN git clone https://github.com/Itz-fork/Nexa-Userbot.git /app
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD bash startup.sh