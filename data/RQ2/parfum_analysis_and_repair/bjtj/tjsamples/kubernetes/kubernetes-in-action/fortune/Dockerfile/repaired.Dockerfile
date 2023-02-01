FROM ubuntu:latest
RUN apt-get update; apt-get install --no-install-recommends -y fortune && rm -rf /var/lib/apt/lists/*;
ADD fortuneloop.sh /bin/fortuneloop.sh
ENTRYPOINT /bin/fortuneloop.sh
