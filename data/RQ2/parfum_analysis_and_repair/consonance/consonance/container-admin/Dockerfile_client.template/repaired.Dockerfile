FROM ubuntu:16.04

# Update the APT cache
# prepare for Java download
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    python-software-properties \
    software-properties-common \
    tree \
    vim \
    sudo \
    less \
    telnet \
    python-pip \
    postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# grab oracle java (auto accept licence)
RUN add-apt-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install --no-install-recommends -y oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

# setup cwltool to support Dockstore
RUN pip install --no-cache-dir setuptools==34.2.0
RUN pip install --no-cache-dir cwl-runner cwltool==1.0.20170217172322 schema-salad==2.2.20170222151604 avro==1.8.1

# install Consonance services
ENV consonance_version={{ CONSONANCE_BINARY_VERSION }}

RUN wget --no-verbose https://github.com/Consonance/consonance/releases/download/${consonance_version}/consonance-arch-${consonance_version}.jar

RUN useradd -ms /bin/bash ubuntu
# the web and Consonance config
WORKDIR /home/ubuntu

# install dockerize
ENV DOCKERIZE_VERSION v0.2.0

RUN wget --no-verbose https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


# TODO: make sure you create these from the .template files and customize them
RUN mkdir -p /home/ubuntu/.youxia /home/ubuntu/.consonance /home/ubuntu/.consonance/self-installs /home/ubuntu/.ssh /home/ubuntu/bin
COPY config /home/ubuntu/.consonance/config
COPY key.pem /home/ubuntu/.ssh/key.pem
COPY init_client.sh /home/ubuntu/init_client.sh

RUN chmod 600 /home/ubuntu/.ssh/key.pem
RUN chmod a+wrx /home/ubuntu/init_client.sh
RUN chown -R ubuntu /home/ubuntu
USER ubuntu
RUN echo "postgres:5432:*:*:postgres" > /home/ubuntu/.pgpass && chmod 600 /home/ubuntu/.pgpass


# for youxia and the consonance command line on the main box
RUN wget --no-verbose https://github.com/Consonance/consonance/releases/download/${consonance_version}/consonance && mv consonance /home/ubuntu/bin && chmod a+x /home/ubuntu/bin/consonance
RUN wget --no-verbose --no-check-certificate https://github.com/Consonance/consonance/releases/download/${consonance_version}/consonance-client-${consonance_version}.jar && mv consonance-client-*.jar /home/ubuntu/.consonance/self-installs/consonance-client-${consonance_version}.jar
RUN mkdir /home/ubuntu/.dockstore && printf "server-url: https://dockstore.org:8443\ntoken: dummy-token" > /home/ubuntu/.dockstore/config
RUN mkdir /home/ubuntu/.dockstore/self-installs && wget --no-verbose --no-check-certificate https://artifacts.oicr.on.ca/artifactory/collab-release/io/dockstore/dockstore-client/{{ CONSONANCE_DOCKSTORE_VERSION }}/dockstore-client-{{ CONSONANCE_DOCKSTORE_VERSION }}.jar && mv dockstore-client-*.jar /home/ubuntu/.dockstore/self-installs/dockstore-client-{{ CONSONANCE_DOCKSTORE_VERSION }}.jar
RUN wget --no-verbose https://github.com/ga4gh/dockstore/releases/download/{{ CONSONANCE_DOCKSTORE_VERSION }}/dockstore && mv dockstore /home/ubuntu/bin && chmod a+x /home/ubuntu/bin/dockstore

# now get a sample CWL and test JSON
RUN wget --no-verbose https://raw.githubusercontent.com/CancerCollaboratory/dockstore-tool-bamstats/1.25-6_1.0/Dockstore.cwl
RUN wget --no-verbose https://raw.githubusercontent.com/CancerCollaboratory/dockstore-tool-bamstats/1.25-6_1.0/sample_configs.json

ENV PATH="/home/ubuntu/bin:${PATH}"

CMD ["dockerize", "-wait", "tcp://webservice:8080", "-timeout", "60s", "/home/ubuntu/init_client.sh"]
