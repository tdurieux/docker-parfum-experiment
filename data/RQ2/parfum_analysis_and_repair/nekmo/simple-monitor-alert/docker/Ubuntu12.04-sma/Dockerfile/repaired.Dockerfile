FROM ubuntu:12.04
RUN apt-get update && apt-get install --no-install-recommends -y python python-pip git sudo && rm -rf /var/lib/apt/lists/*;
COPY tests.sh /tmp/tests.sh
CMD bash /tmp/tests.sh
