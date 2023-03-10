FROM postgres:9.6
ARG POSTGRES_VERSION=9.6
COPY pg_hba.conf /tmp

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y unzip postgresql-server-dev-$POSTGRES_VERSION postgresql-$POSTGRES_VERSION-repmgr && rm -rf /var/lib/apt/lists/*;

# Inherited variables
# ENV POSTGRES_PASSWORD monkey_pass
# ENV POSTGRES_USER monkey_user
# ENV POSTGRES_DB monkey_db

# Name of the cluster you want to start
# ENV CLUSTER_NAME pg_cluster

# priority on electing new master
ENV NODE_PRIORITY 100

# ENV CONFIGS "listen_addresses:'*'"
                                    # in format variable1:value1[,variable2:value2[,...]]
                                    # used for pgpool.conf file

ENV PARTNER_NODES ""
                    # List (comma separated) of all nodes in the cluster, it allows master to be adaptive on restart
                    # (can act as a new standby if new master has been already elected)

ENV MASTER_ROLE_LOCK_FILE_NAME $PGDATA/master.lock
                                                   # File will be put in $MASTER_ROLE_LOCK_FILE_NAME when:
                                                   #    - node starts as a primary node/master
                                                   #    - node promoted to a primary node/master
                                                   # File does not exist
                                                   #    - if node starts as a standby
ENV STANDBY_ROLE_LOCK_FILE_NAME $PGDATA/standby.lock
                                                  # File will be put in $STANDBY_ROLE_LOCK_FILE_NAME when:
                                                  #    - event repmgrd_failover_follow happened
                                                  # contains upstream NODE_ID
                                                  # that basically used when standby changes upstream node set by default
ENV REPMGR_WAIT_POSTGRES_START_TIMEOUT 90
                                            # For how long in seconds repmgr will wait for postgres start on current node
                                            # Should be big enough to perform post replication start which might take from a minute to a few
ENV USE_REPLICATION_SLOTS 1
                                # Use replication slots to make sure that WAL files will not be removed without beein synced to replicas
                                # Recomended(not required though) to put 0 for replicas of the second and deeper levels
ENV CLEAN_OVER_REWIND 0
                        # Clean $PGDATA directory before start standby and not try to rewind
ENV SSH_ENABLE 0
                        # If you need SSH server running on the node

#### Advanced options ####
ENV REPMGR_PID_FILE /tmp/repmgrd.pid
ENV WAIT_SYSTEM_IS_STARTING 5
ENV STOPPING_LOCK_FILE /tmp/stop.pid
ENV REPLICATION_LOCK_FILE /tmp/replication
ENV STOPPING_TIMEOUT 15
ENV CONNECT_TIMEOUT 2
ENV RECONNECT_ATTEMPTS 3
ENV RECONNECT_INTERVAL 5
ENV MASTER_RESPONSE_TIMEOUT 20
ENV LOG_LEVEL INFO
ENV CHECK_PGCONNECT_TIMEOUT 10
ENV REPMGR_SLOT_NAME_PREFIX repmgr_slot_

RUN cp /tmp/pg_hba.conf /var/lib/postgresql/data/

EXPOSE 5432

VOLUME /var/lib/postgresql/data
COPY testdata /opt
COPY init-postgres /opt
COPY dvinstall.zip /opt
WORKDIR /opt
RUN unzip dvinstall.zip
WORKDIR /opt/dvinstall
USER root

RUN /etc/init.d/postgresql start
