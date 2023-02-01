FROM python:3.8-buster
WORKDIR /opt/proxstar
RUN apt-get update -y && apt-get install --no-install-recommends -y python3-dev libldap2-dev libsasl2-dev ldap-utils && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY start_worker.sh start_scheduler.sh .
COPY .git ./.git
COPY *.py .
COPY proxstar ./proxstar
RUN touch proxmox_ssh_key && chmod a+w proxmox_ssh_key # This is some OKD shit.
ENTRYPOINT ddtrace-run python3 wsgi.py
