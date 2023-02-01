FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -y git openssl python-dev python-openssl python-pyasn1 python-twisted python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN pip2 install --no-cache-dir twisted==15.1.0

#custom folder because homedir of user kippo causes a conflict
RUN git clone https://github.com/desaster/kippo.git /kipposource

RUN mv /kipposource/kippo.cfg.dist /kipposource/kippo.cfg

RUN useradd -d /kippo -s /bin/bash -m kippo -g sudo
RUN chown kippo /kipposource/ -R

EXPOSE 2222

USER kippo
WORKDIR /kipposource

CMD ["twistd", "--nodaemon", "-y", "/kipposource/kippo.tac", "--pidfile=/kipposource/kippo.pid"]
