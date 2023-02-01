FROM ubuntu:20.04

COPY . .

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install python3 && \
    apt-get -y --no-install-recommends install python3-pip && \
    pip3 install --no-cache-dir neuralqa && \
    apt-get -y --no-install-recommends install wget && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.8.0-amd64.deb && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.8.0-amd64.deb.sha512 && \
    shasum -a 512 -c elasticsearch-7.8.0-amd64.deb.sha512 && \
    dpkg -i elasticsearch-7.8.0-amd64.deb && \
    service elasticsearch start && \
    sleep 30 && \
         && rm -rf /var/lib/apt/lists/*;

CMD ["neuralqa", "--host", "0.0.0.0", "--port", "80"]