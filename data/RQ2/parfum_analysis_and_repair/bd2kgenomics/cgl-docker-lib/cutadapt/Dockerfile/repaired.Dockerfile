FROM ubuntu:14.04

MAINTAINER John Vivian, jtvivian@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y \
        python-dev \
        build-essential \
        python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir cutadapt==1.18

# Boilerplate
RUN mkdir /opt/cutadapt
COPY wrapper.sh /opt/cutadapt/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["sh", "/opt/cutadapt/wrapper.sh"]
CMD ["--help"]