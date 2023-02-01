#
# About: Test image for development
#

FROM ubuntu:18.04

RUN \
        apt-get update && \
        apt-get -y upgrade && \
        apt-get install --no-install-recommends -y build-essential && \
        apt-get install --no-install-recommends -y net-tools iproute2 iputils-ping \
        apt-transport-https ca-certificates curl stress iperf iperf3 && rm -rf /var/lib/apt/lists/*;

# Install Docker from Docker Inc. repositories.
RUN curl -f -sSL https://get.docker.com/ | sh

# Install Python
RUN apt-get -y --no-install-recommends install python-pip python3.6 && rm -rf /var/lib/apt/lists/*;

# Install Nano as Editor
RUN apt-get -y --no-install-recommends install nano && rm -rf /var/lib/apt/lists/*;

# Install numpy with pip3
RUN pip install --no-cache-dir numpy

ENV HOME /root
WORKDIR /root

# Define default command.
CMD ["bash"]

# Add Directories
ADD client.py /tmp/
ADD probe_agent.py /tmp/
ADD server.py /tmp/
ADD probe_server.py /tmp/
