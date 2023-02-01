FROM ictf_base

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y nginx uwsgi uwsgi-plugin-python3 mysql-server python3-pip python3-virtualenv python3-mysqldb python3-dev python3-setuptools python3-wheel cron daemon && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

COPY ./database /opt/ictf/database
COPY ./scoring_ictf /opt/ictf/scoring_ictf

WORKDIR /opt/ictf/database

RUN chmod +x ./start.sh && ansible-playbook ./provisioning/hephaestus_provisioning/ansible-provisioning.yml

ENTRYPOINT ./start.sh
