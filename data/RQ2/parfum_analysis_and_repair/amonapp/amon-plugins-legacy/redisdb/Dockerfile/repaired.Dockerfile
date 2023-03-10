FROM amonbase:latest

RUN apt-get install --no-install-recommends -y --force-yes amon-agent redis-server && rm -rf /var/lib/apt/lists/*;


RUN /etc/init.d/amon-agent status

ADD hosts /etc/amonagent/hosts
ADD redisdb/redisdb.yml /etc/amonagent/plugins/redisdb/redisdb.yml
ADD redisdb/redisdb.conf.example /etc/amonagent/plugins/redisdb/redisdb.conf.example

RUN ansible-playbook /etc/amonagent/plugins/redisdb/redisdb.yml -i /etc/amonagent/hosts -v

CMD ["/bin/bash"]