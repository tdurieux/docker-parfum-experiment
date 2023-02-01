FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y tcpdump && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends net-tools -y && rm -rf /var/lib/apt/lists/*;

ADD capture.sh /root/capture.sh
ENTRYPOINT ["/bin/bash", "/root/capture.sh"]
