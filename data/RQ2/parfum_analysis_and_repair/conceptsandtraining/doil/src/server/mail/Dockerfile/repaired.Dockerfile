FROM debian:stable

# base
RUN apt-get update
RUN apt-get install --no-install-recommends -y supervisor salt-minion && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim less virt-what net-tools procps git debconf-utils && rm -rf /var/lib/apt/lists/*;

COPY conf/run-supervisor.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-supervisor.sh
CMD ["/usr/local/bin/run-supervisor.sh"]
