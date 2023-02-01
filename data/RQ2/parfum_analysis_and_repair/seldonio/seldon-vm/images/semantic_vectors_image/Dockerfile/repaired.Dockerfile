FROM java7jre_image

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y python-pip zookeeper curl jq && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

ADD ./scripts /scripts

# Define default command.
CMD ["bash"]




