FROM ubuntu:latest

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apt-get update \
 && apt-get install --no-install-recommends git python3 python3-pip -y \
 && git clone https://github.com/badBounty/Dispatcher.git \
 && cd /Dispatcher \
 && pip3 install --no-cache-dir -r requirements.txt \
 && mkdir /output && rm -rf /var/lib/apt/lists/*;

WORKDIR /Dispatcher
VOLUME /output

ENTRYPOINT ["python3", "dispatcher.py"]
CMD ["-h"]
