FROM bitnami/postgresql:14.0.0

USER root

# Explicitly set user/group IDs
RUN useradd -r --gid=0 --uid=1001 postgres

# Install required components for backup
RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y curl groff lzop pv postgresql-client python3-pip daemontools \
	&& pip3 install --no-cache-dir --upgrade pip \
	&& hash -r pip3 \
	&& pip3 install --no-cache-dir wal-e[aws] \
	&& pip3 install --no-cache-dir awscli && rm -rf /var/lib/apt/lists/*;

USER postgres
