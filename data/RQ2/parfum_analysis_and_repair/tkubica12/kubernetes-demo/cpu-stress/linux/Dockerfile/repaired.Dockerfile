FROM ubuntu

COPY runstress.sh /usr/local/bin/runstress.sh

RUN chmod +x /usr/local/bin/runstress.sh && apt-get update && apt-get install --no-install-recommends stress -y && rm -rf /var/lib/apt/lists/*;

CMD ["/usr/local/bin/runstress.sh"]