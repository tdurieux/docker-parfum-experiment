FROM python:3-slim-buster

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y gcc libffi-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/elastalert

ADD requirements*.txt ./

RUN pip3 install --no-cache-dir -r requirements-dev.txt
