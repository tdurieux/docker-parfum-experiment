FROM ubuntu:14.04
MAINTAINER Vadim Markovtsev <v.markovtsev@samsung.com>

# Install Veles
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y wget && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://velesnet.ml/apt trusty main" >> /etc/apt/sources.list && \
    wget -O - https://velesnet.ml/apt/velesnet.ml.gpg.key 2> /dev/null | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python3-veles && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

ENTRYPOINT ["bash"]
