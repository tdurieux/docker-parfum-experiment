FROM efes
ADD docker-run-server.sh /root/run-server.sh
ADD config-docker.toml /etc/efes.toml
ENTRYPOINT ["/bin/bash", "/root/run-server.sh"]
EXPOSE 8500 8501