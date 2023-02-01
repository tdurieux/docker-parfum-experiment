FROM debian:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/AJTimePyro/MegaUploaderbot
WORKDIR /MegaUploaderbot
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 bot.py
