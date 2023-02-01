# A simple Flask app container.
FROM geerlingguy/docker-ubuntu2004-ansible
MAINTAINER Jeff Geerling <geerlingguy@mac.com>

# Install Flask app dependencies.
RUN apt-get update && apt-get install --no-install-recommends -y libmysqlclient-dev build-essential \
  python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir flask flask-sqlalchemy mysqlclient

# Install playbook and run it.
COPY playbook.yml /etc/ansible/playbook.yml
COPY index.py.j2 /etc/ansible/index.py.j2
COPY templates /etc/ansible/templates
RUN mkdir -m 755 /opt/www
RUN ansible-playbook /etc/ansible/playbook.yml --connection=local

EXPOSE 80
