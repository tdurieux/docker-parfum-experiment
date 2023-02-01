FROM debian:stretch-slim
LABEL MAINTAINER "Chandrapal <bnchandrapal@protonmail.com>"

RUN cd /home \
    && apt-get update \
    && apt-get install --no-install-recommends -y git python python-pip nmap exiftool \
    && git clone https://github.com/aancw/Belati.git \
    && cd Belati \
    && git submodule update --init --recursive --remote \
    && pip install --no-cache-dir --upgrade --force-reinstall -r requirements.txt \
    && echo 'alias belati="python /home/Belati/Belati.py"' >> ~/.bashrc && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/Belati

EXPOSE 8000