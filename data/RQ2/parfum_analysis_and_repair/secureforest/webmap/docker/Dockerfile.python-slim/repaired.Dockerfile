# WebMap
# -
# https://github.com/SECUREFOREST/WebMap
# Author: SECUREFOREST, Original version - theMiddle
# -
# Usage:
#   $ cd /opt
#   $ git clone https://github.com/SECUREFOREST/WebMap.git
#   $ cd WebMap/docker
#   $ docker build -t webmap:latest .
#   $ docker run -d -v /opt/WebMap/docker/xml:/opt/xml -p 8000:8000 webmap:latest
#
# Nmap Example:
#   $ nmap -sT -A -oX /tmp/myscan.xml 192.168.1.0/24
#   $ mv /tmp/myscan.xml /opt/WebMap/docker/xml
#
# Now you can point your browser to http://localhost:8000

FROM python:3.7-slim

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /opt/

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl wget git wkhtmltopdf libssl1.1 vim nmap tzdata unzip xz-utils && rm -rf /var/lib/apt/lists/*;

RUN mkdir xml notes && \
    wget -P . https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && rm wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

# copy requirements.txt first
RUN pip3 install --no-cache-dir Django requests xmltodict
RUN django-admin startproject nmapdashboard
WORKDIR /opt/nmapdashboard
RUN git clone https://github.com/SECUREFOREST/WebMap.git nmapreport && rm -rf nmapreport/.git

COPY settings.py /opt/nmapdashboard/nmapdashboard/
COPY urls.py /opt/nmapdashboard/nmapdashboard/
# COPY vimrc /root/.vimrc
COPY tzdata.sh /root/tzdata.sh
COPY startup.sh startup.sh

WORKDIR /opt/nmapdashboard
RUN python3 manage.py migrate
RUN apt-get autoremove -y
RUN ln -s /opt/nmapdashboard/nmapreport/token.py /root/token
RUN chmod +x /root/token

EXPOSE 8000

ENTRYPOINT ["bash", "/startup.sh"]
