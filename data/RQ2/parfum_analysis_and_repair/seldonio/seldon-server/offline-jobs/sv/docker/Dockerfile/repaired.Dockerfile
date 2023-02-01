FROM ubuntu:trusty

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN ( apt-get update && \
    apt-get install --no-install-recommends -y python-pip openjdk-7-jre-headless) && rm -rf /var/lib/apt/lists/*;

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN pip install --no-cache-dir awscli kazoo boto FileChunkIO

ADD ./scripts /semvec

# Define default command.
CMD ["bash"]




