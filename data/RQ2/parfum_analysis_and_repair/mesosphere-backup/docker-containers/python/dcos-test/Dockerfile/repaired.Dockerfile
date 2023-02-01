# Extend the marathon docker image to also include zookeeper and python so that
# we can run integration tests
FROM mesosphere/python-test:latest
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN pip install --no-cache-dir -U virtualenv
RUN virtualenv /dcos-cli
RUN /dcos-cli/bin/pip install -U dcoscli
ENV PATH /dcos-cli/bin:$PATH
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;