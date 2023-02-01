FROM python:3.7.6-stretch

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir ansible
RUN pip install --no-cache-dir openshift jmespath kubernetes
RUN ansible-galaxy collection install community.kubernetes

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass && rm -rf /var/lib/apt/lists/*;

COPY playbooks /ansible/playbooks

WORKDIR /ansible/playbooks

ENTRYPOINT ["ansible-playbook", "-v", "scale-mesh.yml"]
