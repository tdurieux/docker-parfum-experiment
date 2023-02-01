FROM ubuntu:latest

COPY Detonate.sh /Detonate.sh

COPY publish /asa

RUN chmod +x /Asa/Asa

RUN apt-get update && apt-get install --no-install-recommends -y \
    coreutils \
    iproute2 && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["sh", "/Detonate.sh"]