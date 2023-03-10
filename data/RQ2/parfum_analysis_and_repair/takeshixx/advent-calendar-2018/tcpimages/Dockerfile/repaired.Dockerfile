FROM ubuntu:18.04
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir Pillow
WORKDIR /usr/src/app
COPY server.py .
COPY xmas.ttf .
RUN mkdir images/
COPY images images/
RUN chmod +x server.py
CMD ["/usr/src/app/server.py", "0.0.0.0", "19"]
