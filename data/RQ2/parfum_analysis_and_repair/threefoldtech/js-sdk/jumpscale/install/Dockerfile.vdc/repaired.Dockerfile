FROM threefoldtech/phusion:20.04

ARG BRANCH
ARG TRC=true
RUN apt-get update && apt-get install --no-install-recommends etcd-client curl wget git python3-pip python3-venv redis-server tmux nginx restic -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
RUN ln -s ~/.poetry/bin/poetry /usr/local/bin/poetry
RUN mkdir -p /sandbox/code/github/threefoldtech

RUN git clone https://github.com/threefoldtech/js-sdk.git /sandbox/code/github/threefoldtech/js-sdk -b $BRANCH
WORKDIR /sandbox/code/github/threefoldtech/js-sdk
RUN poetry config virtualenvs.create false &&  poetry install --no-dev
RUN poetry shell
RUN /etc/init.d/redis-server start

RUN wget https://github.com/threefoldtech/zinit/releases/download/v0.1/zinit -O /sbin/zinit \
    && chmod +x /sbin/zinit
RUN curl -f -LO "https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl
RUN mv kubectl /sbin/
RUN curl -f https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
RUN wget https://github.com/vmware-tanzu/velero/releases/download/v1.5.3/velero-v1.5.3-linux-amd64.tar.gz
RUN tar -xvf velero-v1.5.3-linux-amd64.tar.gz && rm velero-v1.5.3-linux-amd64.tar.gz
RUN chmod +x velero-v1.5.3-linux-amd64/velero
RUN mv velero-v1.5.3-linux-amd64/velero /sbin/
RUN if [ "$TRC" = "true" ] ; then wget https://github.com/threefoldtech/tcprouter/releases/download/v0.1.0/trc -O /sbin/trc \
    && chmod +x /sbin/trc ; fi

COPY rootfs /
COPY vdc-services /etc/zinit/
COPY certbot/cronjob /etc/cron.d/certbot

RUN if [ "$TRC" = "false" ] ; then rm /etc/zinit/trc.yaml ; fi

ENTRYPOINT [ "zinit", "init" ]
