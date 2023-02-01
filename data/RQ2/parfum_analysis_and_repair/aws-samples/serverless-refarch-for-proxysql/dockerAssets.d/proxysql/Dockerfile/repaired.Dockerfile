FROM proxysql/proxysql:2.0.12

WORKDIR /root

RUN apt-get update && apt-get install --no-install-recommends mysql-client -y && rm -rf /var/lib/apt/lists/*

COPY proxysql.cnf.template /root/proxysql.cnf.template

COPY update.sh /root/update.sh

COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT [ "/root/entrypoint.sh" ]

