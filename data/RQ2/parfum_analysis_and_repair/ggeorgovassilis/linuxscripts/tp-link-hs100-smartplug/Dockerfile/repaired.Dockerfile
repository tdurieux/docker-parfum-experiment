FROM ubuntu:18.04
# USER root

RUN mkdir /hs100
RUN apt update && apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
COPY hs100.sh /hs100/hs100.sh
ENTRYPOINT ["/hs100/hs100.sh"]
