FROM ubuntu:12.04
MAINTAINER tobe <tobeg3oogle@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir mkdocs

ADD . /docs

WORKDIR /docs

EXPOSE 8000

CMD ["mkdocs", "serve"]
