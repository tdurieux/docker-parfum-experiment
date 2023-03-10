FROM splatform/stratos-db-base:leap15_2

# See: https://github.com/docker-library/mariadb/blob/master/10.2/Dockerfile
RUN \
	find /etc/ -name 'my*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/'; 

COPY mariadb-entrypoint.sh /docker-entrypoint.sh
COPY mariadb-ping.sh /dbping.sh

RUN chmod 777 /docker-entrypoint.sh && \
		chmod 777 /dbping.sh

# ENTRYPOINT
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--user=mysql"]