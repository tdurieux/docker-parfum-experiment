# Dockerfile for building an image of scalyr/scalyr-k8s-agent with custom configuration
# files for the Scalyr Agent.
#
# This Dockerfile expects a gzipped tarball called `agent_config.tar.gz` to be in the local
# directory.  This tarball should contain the desired configuration files (`agent.json` and all
# `.json` files in `agent.d`) relative to the `/etc/scalyr-agent-2` configuration directory.
# You can produce such a tarball from a running Scalyr Agent container by issuing the following command:
#
# docker exec scalyr-k8s-agent scalyr-agent-2-config --extract-config - > agent_config.tar.gz
#
# Warning, the string `scalyr-k8s-agent:latest` is hard-coded in the `scalyr-agent-2-config` command
# when executing the `--k8s-create-custom-dockerfile` command.

FROM scalyr/scalyr-k8s-agent:latest
COPY agent_config.tar.gz /tmp/
RUN tar --no-same-owner -C /etc/scalyr-agent-2 -zxf /tmp/agent_config.tar.gz && \
  rm /tmp/agent_config.tar.gz

CMD ["/usr/sbin/scalyr-agent-2", "--no-fork", "--no-change-user", "start"]
