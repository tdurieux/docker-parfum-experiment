FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git curl python3 python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app/
WORKDIR /app/
COPY . /app/
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 -m krypton
