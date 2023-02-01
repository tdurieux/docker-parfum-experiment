FROM neo4j:3.5

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && echo "Europe/Berlin" > /etc/timezone
USER 1000:1000
