# This file describes the standard way to build neosearch, using docker

FROM neosearch-dev
MAINTAINER Tiago Katcipis <tiagokatcipis@gmail.com> (@tiagokatcipis)

# Packaged dependencies
RUN apt-get update && apt-get install -y \
	python-pip \
	openjdk-7-jdk \
	maven \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Install Mkdocs
RUN pip install --no-cache-dir mkdocs

WORKDIR /swagger-codegen

RUN git clone https://github.com/swagger-api/swagger-codegen.git .

RUN mvn package

WORKDIR /go/src/github.com/NeowayLabs/neosearch
