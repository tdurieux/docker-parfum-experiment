FROM ubuntu:18.04
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/app
COPY server.py .
RUN chmod +x server.py
CMD ["/usr/src/app/server.py"]
