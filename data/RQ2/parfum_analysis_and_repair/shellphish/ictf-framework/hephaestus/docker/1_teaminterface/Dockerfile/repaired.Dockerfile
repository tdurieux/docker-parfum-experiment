FROM ictf_base

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y nginx python3-pip python3-virtualenv python3-dev libjpeg8 libjpeg-dev zlib1g zlib1g-dev libpng-dev libmemcached-dev libmemcached-tools libgeoip1 libgeoip-dev geoip-bin geoip-database redis-server && rm -rf /var/lib/apt/lists/*;

COPY ./teaminterface /opt/ictf/teaminterface

WORKDIR /opt/ictf/teaminterface

RUN pip install --no-cache-dir -r requirements.txt

RUN ansible-playbook provisioning/hephaestus_provisioning/ansible-provisioning.yml --become  --extra-vars ICTF_DB_API_ADDRESS="database.ictf"

RUN chmod +x ./start.sh

ENTRYPOINT ./start.sh
