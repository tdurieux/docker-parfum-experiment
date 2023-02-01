FROM amd64/ubuntu:latest

MAINTAINER cade <cade.call@mediciventures.com>

EXPOSE $RPCPORT

EXPOSE $PORT

RUN apt-get update && apt-get install --no-install-recommends -y bash net-tools && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash hive

RUN mkdir /etc/hive

RUN mkdir /var/lib/hive

RUN chown hive:hive /etc/hive /var/lib/hive

WORKDIR /home/hive

COPY --chown=hive:hive linux64/* /home/hive/

COPY --chown=hive:hive run.sh /home/hive/

USER hive

CMD ["/home/hive/run.sh"]
