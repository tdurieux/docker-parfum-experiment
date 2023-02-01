FROM ubuntu:16.04

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
 ffmpeg \
 sox \
 python3 \
 python3-pip \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

# -u: unbuffered output; otherwise docker doesn't print output until process is finished
ENTRYPOINT ["python3", "-u", "cli.py"]
