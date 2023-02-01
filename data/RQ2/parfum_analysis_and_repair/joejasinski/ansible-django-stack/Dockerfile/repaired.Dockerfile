FROM ubuntu:18.04
MAINTAINER Joe Jasinski

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ansible python-apt && rm -rf /var/lib/apt/lists/*;

ADD . /srv/ansible/

RUN ansible-playbook -vvvv --inventory-file=/srv/ansible/ansible/inventory.ini \
   /srv/ansible/ansible/playbook-all.yml -c local

CMD ["/srv/ansible/docker-utils/run.sh"]
EXPOSE 80 443
