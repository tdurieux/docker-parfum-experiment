FROM arm32v7/ubuntu:latest

MAINTAINER cade <cade.call@mediciventures.com>

EXPOSE $RPCPORT

EXPOSE $PORT

RUN useradd -ms /bin/bash hive

RUN mkdir /etc/hive

RUN mkdir /var/lib/hive

RUN chown hive:hive /etc/hive /var/lib/hive

WORKDIR /home/hive

COPY --chown=hive:hive linux64/* ./run.sh /home/hive/

USER hive

CMD ["/home/hive/run.sh"]