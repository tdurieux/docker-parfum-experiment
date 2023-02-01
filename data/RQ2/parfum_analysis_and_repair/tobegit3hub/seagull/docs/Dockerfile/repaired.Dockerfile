FROM ubuntu:14.10
MAINTAINER tobe <tobeg3oogle@gmail.com>

RUN apt-get -y update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*; # Install mkdocs

RUN pip install --no-cache-dir mkdocs

# Add seagull docs
ADD . /docs
WORKDIR /docs

EXPOSE 8000

CMD ["mkdocs", "serve"]
