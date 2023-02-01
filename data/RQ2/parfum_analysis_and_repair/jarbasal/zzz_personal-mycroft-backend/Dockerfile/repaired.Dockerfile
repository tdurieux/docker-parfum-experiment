FROM ubuntu:latest

RUN apt-get update && \
  apt-get install --no-install-recommends -y git python3 python3-dev python3-pip curl build-essential libffi-dev python3-numpy rustc && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir SpeechRecognition==3.8.1

COPY . /tmp/ovos-backend
RUN pip3 install --no-cache-dir /tmp/ovos-backend

ENTRYPOINT ovos-local-backend --flask-host 0.0.0.0