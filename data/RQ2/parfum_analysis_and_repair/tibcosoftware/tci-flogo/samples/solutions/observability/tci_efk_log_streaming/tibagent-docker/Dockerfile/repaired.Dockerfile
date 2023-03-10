FROM ubuntu
WORKDIR /opt/tci/tibagent/bin
CMD ["/opt/tci/tibagent/bin/startup.sh"]
ADD ./startup.sh ./startup.sh
COPY ./tibagent ./tibagent
RUN chmod +x ./tibagent
RUN { \
 apt-get update; \
 apt-get install --no-install-recommends -y ca-certificates; \
 apt-get install --no-install-recommends -y socat; \
 apt-get install --no-install-recommends -y gawk; \
} && rm -rf /var/lib/apt/lists/*;
