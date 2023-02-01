FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
	apt-get install --no-install-recommends -y openjdk-8-jre && \
	rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get -qq update && apt-get -y upgrade && \
	apt install --no-install-recommends -y wget libfindbin-libs-perl software-properties-common unzip && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip -O /tmp/fastqc.zip && \
    unzip /tmp/fastqc.zip -d /opt/ && \
    rm /tmp/fastqc.zip && \
    chmod 777 /opt/FastQC/fastqc

ENV PATH="/opt/FastQC/:${PATH}"

ENTRYPOINT ["fastqc"]
