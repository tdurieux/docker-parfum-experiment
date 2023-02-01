# Dockerfile for trackmap perform_analysis script
# version 0.1
FROM ubuntu:trusty
MAINTAINER Peter van Heusden <pvh@webbedfeet.co.za>
RUN apt-get update && apt-get install --no-install-recommends -y \
    libfontconfig1 \
    python-pip \
    traceroute \
    unzip \
    wget \
    zip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir \
    PySocks \
    termcolor \
    tldextract
RUN adduser --disabled-password --gecos "Track Map User" trackmap
COPY . /home/trackmap/trackmap
RUN chown -R trackmap:trackmap /home/trackmap/trackmap
USER trackmap
WORKDIR /home/trackmap/trackmap
RUN bash -c /home/trackmap/trackmap/fetch_phantomjs.sh
ENTRYPOINT ["./perform_analysis.py"]
