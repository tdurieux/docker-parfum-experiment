FROM debian:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git curl python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN apt -qq install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN mkdir /app/
WORKDIR /app/
COPY . /app/
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 main.py
