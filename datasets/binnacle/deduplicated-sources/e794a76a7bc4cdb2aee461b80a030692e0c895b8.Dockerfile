# Dockerfile for building an image of scalyr/scalyr-docker-agent with custom configuration
# files for the Scalyr Agent.
#
# This Dockerfile expects a gzipped tarball called `agent_config.tar.gz` to be in the local
# directory.  This tarball should contain the desired configuration files (`agent.json` and all
# `.json` files in `agent.d`) relative to the `/etc/scalyr-agent-2` configuration directory.
# You can produce such a tarball using a running Scalyr Agent container by issuing the following command:
#
# docker exec scalyr-docker-agent scalyr-agent-2-config --extract-config - > agent_config.tar.gz
#
# Warning, the string `scalyr-docker-agent:latest` is hard-coded in the `scalyr-agent-2-config` command to
# help when executing the `--docker-create-custom-dockerfile` command.
FROM scalyr/scalyr-docker-agent:latest
COPY agent_config.tar.gz /tmp/
RUN tar --no-same-owner -C /etc/scalyr-agent-2 -zxf /tmp/agent_config.tar.gz && \
  rm /tmp/agent_config.tar.gz

CMD ["/usr/sbin/scalyr-agent-2", "--no-fork", "--no-change-user", "start"]
