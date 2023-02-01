FROM debian:9

RUN apt-get update \
	&& apt-get install --no-install-recommends dirmngr -y \
	&& apt-key adv --fetch-keys http://packages.nixys.ru/debian/repository.gpg.key \
	&& apt-key adv --keyserver keys.gnupg.net --recv-keys 8507EFA5 \
	&& echo "deb [arch=amd64] http://packages.nixys.ru/debian/ stretch main" > /etc/apt/sources.list.d/packages.nixys.ru.list \
	&& echo "deb http://repo.percona.com/apt stretch main" > /etc/apt/sources.list.d/percona-release.list.list \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive \
		apt-get --no-install-recommends install -y \
			apt-utils \
			nxs-backup \
			nxs-backup-ext-etcd \
			python3 \
			python3-pip \
			python3-setuptools \
			python3-yaml \
			mysql-client \
			percona-xtrabackup \
			postgresql-client \
			mongodb-clients \
			redis-tools \
			s3fs \
			fuse \
			ssmtp \
	&& pip3 install --no-cache-dir setuptools jinja2-cli pyyaml && rm -rf /var/lib/apt/lists/*;

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/nxs-backup", "start", "all"]
