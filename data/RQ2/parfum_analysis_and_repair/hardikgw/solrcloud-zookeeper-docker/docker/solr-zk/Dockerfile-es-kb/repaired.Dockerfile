FROM search/fluentd-elastic-kibana-docker
MAINTAINER hardikgw@gmail.com
RUN \
	apt-get install -y --no-install-recommends monit && \
	echo "tail -F /var/log/td-agent/td-agent.log" >> start.sh && rm -rf /var/lib/apt/lists/*;
EXPOSE 5601 9200 9300 24224