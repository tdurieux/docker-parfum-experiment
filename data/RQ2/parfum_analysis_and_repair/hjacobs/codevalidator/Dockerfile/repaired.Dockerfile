FROM ubuntu:14.04
MAINTAINER Henning Jacobs <henning@jacobs1.de>

RUN apt-get update && apt-get -y --no-install-recommends install python-lxml pep8 pyflakes nodejs npm nailgun python-sqlparse python-yaml && rm -rf /var/lib/apt/lists/*;
RUN npm install -g jshint && npm cache clean --force;

ADD . /codevalidator
ADD pgsqlparser/PgSqlParser /opt/codevalidator/PgSqlParser

VOLUME ["/workdir"]

ENTRYPOINT ["/codevalidator/codevalidator.py"]
