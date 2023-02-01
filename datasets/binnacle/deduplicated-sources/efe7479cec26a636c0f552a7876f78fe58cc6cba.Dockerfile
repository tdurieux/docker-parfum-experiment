FROM digitalrebar/deploy-service-wrapper

ARG DR_TAG
# Set our command
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

RUN groupadd -r rebar && useradd -r -u 1000 -g rebar -p '$6$afAL.34B$T2WR6zycEe2q3DktVtbH2orOroblhR6uCdo5n3jxLsm47PBm9lwygTbv3AjcmGDnvlh0y83u2yprET8g9/mve.' -m -d /home/rebar -s /bin/bash rebar \
  && mkdir -p /opt /etc/sudoers.d /home/rebar/.ssh /var/run/rebar /var/cache/rebar/ansible_playbook /home/rebar/.ansible \
  && chown rebar:rebar /var/run/rebar /home/rebar/.ansible /home/rebar/.ssh /var/cache/rebar/ansible_playbook

COPY rebar_sudoer /etc/sudoers.d/rebar
COPY ssh_config /home/rebar/.ssh/config
COPY rebar-runner.json /etc/consul.d/rebar-runner.json
COPY core /opt/digitalrebar/core
RUN test -d /opt/digitalrebar/core/rails \
    || { rm -rf /opt/digitalrebar; git clone https://github.com/digitalrebar/digitalrebar /opt/digitalrebar; }

RUN apt-get -y update \
  && apt-get -y install software-properties-common wget \
  && apt-add-repository ppa:brightbox/ruby-ng \
  && add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-backports main restricted universe multiverse" \
  && add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" \
  && apt-add-repository ppa:ansible/ansible \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get -y update \
  && apt-get -y --no-install-recommends install ruby2.4 ruby2.4-dev make cmake curl libxml2-dev libcurl4-openssl-dev libssl-dev build-essential jq sudo postgresql-client-9.5 libpq5 libpq-dev autoconf uuid-runtime ipmitool ansible python-netaddr python-dns python-pip ssh tzdata iputils-ping \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install dnspython
RUN gem install bundler \
  && gem install net-http-digest_auth \
  && gem install nio4r -v 1.2.0
RUN mkdir -p /var/run/rebar /var/cache/rebar/cookbooks /var/cache/rebar/gems /var/cache/rebar/ \
  && chown -R rebar:rebar /opt/digitalrebar /var/run/rebar /var/cache/rebar /home/rebar/.ssh \
  && chmod 755 /home/rebar/.ssh
RUN su -l -c 'cd /opt/digitalrebar/core/rails; bundle install --path /var/cache/rebar/gems --standalone --binstubs /var/cache/rebar/bin' rebar
RUN ln -s /var/cache/rebar/bin/puma /usr/bin/puma \
  && ln -s /var/cache/rebar/bin/pumactl /usr/bin/pumactl \
  && chown rebar:rebar /home/rebar/.ssh/config \
  && chmod 644 /home/rebar/.ssh/config \
  && openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out /var/run/rebar/server.key \
  && openssl req -new -key /var/run/rebar/server.key -out /var/run/rebar/server.csr -subj "/C=US/ST=Texas/L=Austin/O=RackN/OU=RebarAPI/CN=neode.net" \
  && openssl x509 -req -days 365 -in /var/run/rebar/server.csr -signkey /var/run/rebar/server.key -out /var/run/rebar/server.crt \
  && rm /var/run/rebar/server.csr \
  && chmod 400 /var/run/rebar/server.key /var/run/rebar/server.crt \
  && chown rebar:rebar /var/run/rebar/server.key /var/run/rebar/server.crt
RUN curl -fgL -o '/tmp/chef.deb' \
  'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/10.04/x86_64/chef_11.18.12-1_amd64.deb' \
  && dpkg -i /tmp/chef.deb && rm -f /tmp/chef.deb \
  && sed -i '/\[ssh_connection\]/a ssh_args=' /etc/ansible/ansible.cfg

ADD http://localhost:28569/${DR_TAG}/linux/amd64/amttool /usr/local/bin/amttool
ADD http://localhost:28569/${DR_TAG}/linux/amd64/wscli /usr/local/bin/wscli
RUN chmod 755 /usr/local/bin/*

COPY entrypoint.d/*.sh /usr/local/entrypoint.d/
