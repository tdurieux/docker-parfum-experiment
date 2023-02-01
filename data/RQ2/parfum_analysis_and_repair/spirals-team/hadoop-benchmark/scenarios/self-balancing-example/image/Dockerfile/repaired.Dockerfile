FROM spirals/hadoop-benchmark:hadoop-benchmark
MAINTAINER Bo ZHANG <bo.zhang@inria.fr>

# prerequisite
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -yqq && \
    apt-get install --no-install-recommends -yqq \
				bc && rm -rf /var/lib/apt/lists/*;

ADD self-balancing /self-balancing
ADD capacity-scheduler.xml /usr/local/hadoop/etc/hadoop/

ADD after-start.sh /

WORKDIR /self-balancing

ENTRYPOINT [ "/entrypoint.sh" ]
