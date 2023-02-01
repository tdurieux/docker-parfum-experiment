FROM debian:8.4
RUN apt-get update
RUN apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
COPY tests.sh /tmp/tests.sh
CMD bash /tmp/tests.sh