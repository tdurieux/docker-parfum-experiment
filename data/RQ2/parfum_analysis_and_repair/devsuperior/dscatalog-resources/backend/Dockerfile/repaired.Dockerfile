FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install --no-install-recommends -y curl unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip

RUN apt-get install --no-install-recommends -y iputils-ping \
  && apt-get install --no-install-recommends -y vim \
  && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;

VOLUME /tmp

CMD ["bash"]
