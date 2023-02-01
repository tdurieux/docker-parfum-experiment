# docker build --network packt -t eshadoop .
# docker run --rm --network packt --name eshadoop -it eshadoop /usr/app/commands.sh
FROM ubuntu:16.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install OpenJDK 8
RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Install Python
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.6 && \
    apt-get install --no-install-recommends -y python3.6-dev && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y python3.6-venv && rm -rf /var/lib/apt/lists/*;

RUN python3.6 -m pip install pip --upgrade && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /usr/app/
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

RUN cd /usr/local/lib/python3.6/dist-packages/pyspark/jars && \
    wget https://central.maven.org/maven2/org/elasticsearch/elasticsearch-spark-20_2.11/7.0.0/elasticsearch-spark-20_2.11-7.0.0.jar

RUN ["chmod", "+x", "/usr/app/commands.sh"]
ENTRYPOINT ["/usr/app/commands.sh"]
