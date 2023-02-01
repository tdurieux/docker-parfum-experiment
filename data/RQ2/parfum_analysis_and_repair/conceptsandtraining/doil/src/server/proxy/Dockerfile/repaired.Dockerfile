FROM debian:stable

RUN apt-get update
RUN apt-get install --no-install-recommends -y supervisor salt-minion && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim less virt-what net-tools procps && rm -rf /var/lib/apt/lists/*;

EXPOSE 80 443

COPY conf/run-supervisor.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-supervisor.sh
CMD ["/usr/local/bin/run-supervisor.sh"]
