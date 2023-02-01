FROM efes
RUN apt-get update && apt-get -y --no-install-recommends install fuse && rm -rf /var/lib/apt/lists/*;
ADD docker-run-tracker.sh /root/run-tracker.sh
ADD config-docker.toml /etc/efes.toml
ENTRYPOINT ["/bin/bash", "/root/run-tracker.sh"]
EXPOSE 8001
