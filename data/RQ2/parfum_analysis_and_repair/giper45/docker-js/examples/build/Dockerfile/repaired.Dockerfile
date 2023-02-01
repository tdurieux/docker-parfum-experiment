FROM ubuntu

RUN \
  apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
COPY a.txt /a.txt

CMD ["bash"]
