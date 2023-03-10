FROM amonbase:latest

RUN apt-get install --no-install-recommends -y --force-yes amon-agent && rm -rf /var/lib/apt/lists/*;


RUN /etc/init.d/amon-agent status

ADD hosts /etc/amonagent/hosts
ADD apache/ /etc/amonagent/plugins/apache/

RUN ansible-playbook /etc/amonagent/plugins/apache/apache.yml -i /etc/amonagent/hosts -v

RUN cat /var/log/apache2/access.log
RUN ls -lh /var/log/apache2
RUN amonpm test apache

CMD ["/bin/bash"]