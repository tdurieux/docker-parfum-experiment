FROM amonbase:latest

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes amon-agent postgresql && rm -rf /var/lib/apt/lists/*;

ADD hosts /etc/amonagent/hosts
ADD postgres/postgres.yml /etc/amonagent/plugins/postgres/postgres.yml
ADD postgres/postgres.conf.example /etc/amonagent/plugins/postgres/postgres.conf.example

RUN ansible-playbook /etc/amonagent/plugins/postgres/postgres.yml -i /etc/amonagent/hosts -v

CMD ["/bin/bash"]