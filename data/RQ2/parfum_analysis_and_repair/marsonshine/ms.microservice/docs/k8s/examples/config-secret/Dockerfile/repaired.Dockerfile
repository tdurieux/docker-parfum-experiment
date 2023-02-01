FROM ubuntu:latest
RUN apt-get update ; apt-get -y --no-install-recommends install fortune && rm -rf /var/lib/apt/lists/*;
ADD fortuneloop.sh /bin/fortuneloop.sh
ENTRYPOINT ["/bin/fortuneloop.sh"]