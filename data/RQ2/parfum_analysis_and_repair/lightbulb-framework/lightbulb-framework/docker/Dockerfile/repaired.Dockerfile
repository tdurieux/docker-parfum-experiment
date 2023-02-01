FROM debian:latest
EXPOSE 8000 8001 8002 8080 8081 8082
RUN apt-get -y update && apt-get install --no-install-recommends -y flex python-pip python-dev build-essential libmysqlclient-dev wget sudo && rm -rf /var/lib/apt/lists/*;
ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mysql-server \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
EXPOSE 3306/tcp
VOLUME ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]
RUN pip install --no-cache-dir MySQL-python
RUN pip install --no-cache-dir lightbulb-framework
RUN yes Y | lightbulb status
CMD lightbulb status
ENTRYPOINT sh -c lightbulb
