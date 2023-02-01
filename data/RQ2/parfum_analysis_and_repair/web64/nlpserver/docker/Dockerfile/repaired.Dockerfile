# Use the official image as a parent image.
FROM python:3.8.5-slim-buster

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

# Set the working directory.
WORKDIR /usr/src
RUN git clone https://github.com/web64/nlpserver.git
WORKDIR /usr/src/nlpserver

# Install dependencies
RUN apt-get -y --no-install-recommends install pkg-config && \
  apt-get -y --no-install-recommends install -y python-numpy libicu-dev && \
  apt-get -y --no-install-recommends install -y python3-pip && \
  python3 -m pip install -r requirements.txt && rm -rf /var/lib/apt/lists/*;

# Download language models
RUN polyglot download LANG:en

RUN python3 -m spacy download en && \
	python3 -m spacy download xx

# Set supervisor config
COPY nlpserver.conf /etc/supervisor/conf.d
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 6400
