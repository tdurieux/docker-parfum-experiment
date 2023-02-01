FROM ubuntu:16.04

# Update the APT cache
# prepare for Java download
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    python-software-properties \
    software-properties-common \
    git \
    vim \
    telnet \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends software-properties-common \
    && apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get install --no-install-recommends -y ansible && rm -rf /var/lib/apt/lists/*;

# grab oracle java (auto accept licence)
RUN add-apt-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install --no-install-recommends -y oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

# install Consonance services
ENV consonance_version={{ CONSONANCE_BINARY_VERSION }}

RUN wget --no-verbose https://github.com/Consonance/consonance/releases/download/${consonance_version}/consonance-arch-${consonance_version}.jar

# install dockerize
ENV DOCKERIZE_VERSION v0.2.0

RUN wget --no-verbose https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# the web and Consonance config
COPY config .
ADD init_provisioner.sh .

RUN git clone https://github.com/Consonance/container-host-bag.git  /container-host-bag
# we need the branch that is compatible with Ansible 2
#RUN (cd /container-host-bag && git checkout develop_2)
RUN (cd /container-host-bag && git checkout {{ CONSONANCE_HOST_BAG_VERSION }})

RUN chmod u+x init_provisioner.sh
# TODO: make sure you create these from the .template files and customize them
RUN mkdir -p /root/.youxia /root/.consonance /root/.consonance/self-installs /root/.ssh
COPY youxia_config /root/.youxia/config
COPY config /root/.consonance/config
COPY key.pem /root/.ssh/key.pem
RUN chmod 600 /root/.ssh/key.pem
COPY aws.config /root/.aws/config
RUN mkdir /consonance_logs && chmod a+rx /consonance_logs

# the Ansible-based setup
COPY bag_params.json /container-host-bag/example_params.json
COPY example_tags.json /container-host-bag/example_tags.json

# patch for Ansible
COPY ssh.py /usr/lib/python2.7/dist-packages/ansible/plugins/connection/ssh.py
RUN rm -f /usr/lib/python2.7/dist-packages/ansible/plugins/connection/ssh.pyc

# TODO: 1) update the above to have my AWS creds in it and 2) create the admin user in postgres db
# Waiting for postgres and rabbitmq services
CMD ["dockerize", "-wait", "tcp://webservice:8080", "-timeout", "60s", "./init_provisioner.sh"]
