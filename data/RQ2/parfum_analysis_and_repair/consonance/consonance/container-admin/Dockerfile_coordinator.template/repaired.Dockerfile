FROM ubuntu:16.04

# Update the APT cache
# prepare for Java download
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    python-software-properties \
    software-properties-common \
    telnet \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# grab oracle java (auto accept licence)
RUN add-apt-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install --no-install-recommends -y oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

# install Consonance services
ENV consonance_version={{ CONSONANCE_BINARY_VERSION }}

RUN wget --no-verbose https://github.com/Consonance/consonance/releases/download/${consonance_version}/consonance-arch-${consonance_version}.jar

# install dockerize
ENV DOCKERIZE_VERSION v0.2.0

RUN wget --no-verbose https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY config .
ADD init_coordinator.sh .


RUN chmod u+x init_coordinator.sh
COPY config /root/.consonance/config
RUN mkdir /consonance_logs && chmod a+rx /consonance_logs


# TODO: 1) update the above to have my AWS creds in it and 2) create the admin user in postgres db
# Waiting for postgres and rabbitmq services
CMD ["dockerize", "-wait", "tcp://webservice:8080", "-timeout", "60s", "./init_coordinator.sh"]
