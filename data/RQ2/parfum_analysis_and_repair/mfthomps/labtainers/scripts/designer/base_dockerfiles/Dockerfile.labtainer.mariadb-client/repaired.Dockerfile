ARG registry
FROM $registry/labtainer.network2
LABEL description="This is base Docker image for Labtainer mariadb clients"
ENV DEBIAN_FRONTEND noninteractive
RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
RUN chmod +x mariadb_repo_setup
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN ./mariadb_repo_setup
RUN apt-get update && apt-get install --no-install-recommends -y mariadb-client && rm -rf /var/lib/apt/lists/*;
# modified to create new instance
RUN systemd-machine-id-setup

