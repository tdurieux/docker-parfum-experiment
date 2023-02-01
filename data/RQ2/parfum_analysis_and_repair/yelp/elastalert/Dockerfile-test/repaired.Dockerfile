FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y --no-install-recommends install build-essential python3.6 python3.6-dev python3-pip libssl-dev git && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/elastalert

ADD requirements*.txt ./
RUN pip3 install --no-cache-dir -r requirements-dev.txt
