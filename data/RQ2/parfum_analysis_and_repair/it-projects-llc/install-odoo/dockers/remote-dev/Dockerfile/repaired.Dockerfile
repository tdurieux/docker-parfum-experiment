FROM itprojectsllc/install-odoo:8.0

USER root

ENV BUILD_DATE=2016_11_01

RUN apt-get update

RUN apt-get install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y vim tmux openssh-server emacs24 && rm -rf /var/lib/apt/lists/*;

COPY ./start.sh /
COPY ./entrypoint.sh /entrypoint-sshd.sh
COPY ./chromium.sh /
COPY ./odoo.sh /
COPY ./emacs-server.sh /
COPY ./emacs-client.sh /

RUN mkdir /var/run/sshd && \
    mkdir /opt/odoo/.ssh/ && \
    chown odoo:odoo /opt/odoo/.ssh/ && \
    rm /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint-sshd.sh"]
