FROM python:3.8-slim-buster
COPY requirements.txt /
RUN apt update && apt install --no-install-recommends -y build-essential libsasl2-dev libldap2-dev libssl-dev libjansson-dev libltdl7 libnss3 libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r /requirements.txt
RUN rm /requirements.txt
RUN rm -rf /var/lib/apt/lists/*
