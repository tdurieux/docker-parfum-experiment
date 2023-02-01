FROM ubuntu:latest

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apt-get update -y \
 && apt-get install --no-install-recommends build-essential git python3 python3-pip tor -y \
 && git clone https://github.com/sherlock-project/sherlock.git \
 && cd /sherlock \
 && pip3 install --no-cache-dir -r requirements.txt \
 && mkdir /output && rm -rf /var/lib/apt/lists/*;

WORKDIR /sherlock/sherlock

VOLUME /output

ENTRYPOINT ["python3", "sherlock.py"]

CMD ["-h"]
