FROM python:3.10.4-slim-buster
RUN apt update && apt upgrade -y
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget python3-pip curl bash neofetch ffmpeg software-properties-common && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .

RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir -U -r requirements.txt
COPY start /start
CMD ["/bin/bash", "/start"]
