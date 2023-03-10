FROM ubuntu:16.04

MAINTAINER FOSSEE <pythonsupport@fossee.in>

RUN apt-get update && \
 apt-get install --no-install-recommends git python3-pip libmysqlclient-dev sudo default-jre default-jdk -y && rm -rf /var/lib/apt/lists/*;

VOLUME /Sites/online_test

ADD Files/requirements-* /tmp/

RUN pip3 install --no-cache-dir -r /tmp/requirements-codeserver.txt && mkdir -p /Sites/online_test/yaksh_data/output /Sites/online_test/yaksh_data/data

WORKDIR /Sites/online_test

ADD Files/Start-codeserver.sh /Sites

EXPOSE 53579

CMD [ "/bin/bash" , "/Sites/Start-codeserver.sh" ]
