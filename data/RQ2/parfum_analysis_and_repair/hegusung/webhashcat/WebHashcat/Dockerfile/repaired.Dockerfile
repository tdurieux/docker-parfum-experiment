FROM ubuntu:focal

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip libmysqlclient-dev && \
	pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget make clinfo build-essential git libcurl4-openssl-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

ENV HASHCAT_VERSION master
RUN git clone https://github.com/hashcat/hashcat.git && cd hashcat && git checkout ${HASHCAT_VERSION} && make install -j4

WORKDIR /webhashcat

# Installing requirements
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copying files
COPY . .
RUN chmod +x /webhashcat/entrypoint.sh
RUN chmod 777 /webhashcat/Files/tmp

# Preparing configuration
RUN mv /webhashcat/WebHashcat/settings.py.docker /webhashcat/WebHashcat/settings.py
RUN mv /webhashcat/settings.ini.docker /webhashcat/settings.ini

# Entrypoint
ENTRYPOINT ["/webhashcat/entrypoint.sh"]

