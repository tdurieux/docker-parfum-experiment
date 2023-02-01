FROM python:3.9-bullseye
RUN apt-get update && apt-get install --no-install-recommends -y git wireless-tools iputils-ping openssh-client sshpass expect && rm -rf /var/lib/apt/lists/*
ADD requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt
ADD common.py mockcamera.py mockgpio.py /
