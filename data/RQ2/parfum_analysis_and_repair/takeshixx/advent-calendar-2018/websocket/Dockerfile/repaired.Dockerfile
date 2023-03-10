FROM ubuntu:18.04

#RUN \
#  apt-get update && \
#  apt-get -y upgrade && \
#  apt-get install -y gnupg gnupg2 lsb-release ca-certificates linux-headers-$(uname -r)

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y python3 python3-pip git && \
  pip3 install --no-cache-dir git+https://github.com/Pithikos/python-websocket-server && rm -rf /var/lib/apt/lists/*;


WORKDIR /usr/src/app
COPY server.py .
RUN chmod +x server.py
COPY success .
CMD ["python3", "/usr/src/app/server.py"]
