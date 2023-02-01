FROM ubuntu:16.04

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    openjdk-8-jdk-headless && rm -rf /var/lib/apt/lists/*;

COPY elasticsearch-1.3.9.tar.gz /elasticsearch-1.3.9.tar.gz
RUN tar xzvf /elasticsearch-1.3.9.tar.gz && rm /elasticsearch-1.3.9.tar.gz

ENV PATH=$PATH:/elasticsearch-1.3.9/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300
