FROM guacamole/guacamole

RUN apt-get update ; apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

ADD start.sh /opt/guacamole/bin/start.sh
ADD run.sh /run.sh

CMD /run.sh

