FROM ubuntu:16.04
LABEL maintainer="alexandru@pusher.com"
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
ADD message.txt /message.txt
ADD run.sh /run.sh
RUN chmod a+x /run.sh
ENTRYPOINT ["bash /run.sh"]
CMD ["https://httpbin/org/user-agent"]
