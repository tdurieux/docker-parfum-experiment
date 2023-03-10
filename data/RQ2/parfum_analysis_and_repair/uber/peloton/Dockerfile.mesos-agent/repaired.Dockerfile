ARG MESOS_AGENT_VERSION=1.7.1

FROM mesosphere/mesos-slave:$MESOS_AGENT_VERSION

# Install python2.7, used by thermos executor
RUN mkdir -p /usr/local/lib/python2.7 \
  && mv /usr/lib/python2.7/site-packages /usr/local/lib/python2.7/dist-package \
  && ln -s /usr/local/lib/python2.7/dist-packages /usr/lib/python2.7/site-packages \
  && apt-get -yqq update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yqq install python2.7 && rm -rf /var/lib/apt/lists/*;

ARG GIT_REPO=git-repo

# Install thermos executor
ADD $GIT_REPO/docker/thermos_executor_0.19.1.pex /usr/share/aurora/bin/thermos_executor.pex
