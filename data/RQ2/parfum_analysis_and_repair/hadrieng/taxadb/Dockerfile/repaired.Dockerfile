FROM python:3

MAINTAINER Hadrien Gourlé <gourlehadrien@gmail.com>

WORKDIR /usr/src/app

RUN pip install --no-cache-dir taxadb

CMD [ "taxadb" ]
