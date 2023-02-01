FROM amonbase:latest

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes amon-agent mysql-server && rm -rf /var/lib/apt/lists/*;

ADD hosts /etc/amonagent/hosts
ADD mysql/mysql.yml /etc/amonagent/plugins/mysql/mysql.yml
ADD mysql/mysql.conf.example /etc/amonagent/plugins/mysql/mysql.conf.example

RUN ansible-playbook /etc/amonagent/plugins/mysql/mysql.yml -i /etc/amonagent/hosts -v

CMD ["/bin/bash"]