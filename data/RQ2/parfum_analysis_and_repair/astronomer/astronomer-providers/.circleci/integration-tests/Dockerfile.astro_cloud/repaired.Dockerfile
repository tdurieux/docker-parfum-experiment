# Deploy from astro runtime image
FROM quay.io/astronomer/astro-runtime:5.0.6-base

ENV AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=False
ENV AWS_NUKE_VERSION=v2.17.0

USER root

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get install --no-install-recommends -y wget procps gnupg2 && rm -rf /var/lib/apt/lists/*;

# Install openjdk-8
RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' \
    && apt-get update && apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y unzip \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get install --no-install-recommends -y curl gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

# Set Hive and Hadoop versions.
ENV HIVE_LIBRARY_VERSION=hive-2.3.9
ENV HADOOP_LIBRARY_VERSION=hadoop-2.10.1

# install AWS CLI
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install;

# install AWS nuke
RUN wget --quiet  \
    "https://github.com/rebuy-de/aws-nuke/releases/download/${AWS_NUKE_VERSION}/aws-nuke-${AWS_NUKE_VERSION}-linux-amd64.tar.gz" \
    && tar -xzvf aws-nuke-${AWS_NUKE_VERSION}-linux-amd64.tar.gz -C /usr/local/bin \
    && mv /usr/local/bin/aws-nuke-${AWS_NUKE_VERSION}-linux-amd64 /usr/local/bin/aws-nuke && rm aws-nuke-${AWS_NUKE_VERSION}-linux-amd64.tar.gz

# install eksctl
RUN curl -f --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin

# install kubectl
RUN curl -f -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin

# Install Apache Hive (Download same version of library to match EMR Hive version created by DAG)
RUN curl -f "https://downloads.apache.org/hive/$HIVE_LIBRARY_VERSION/apache-$HIVE_LIBRARY_VERSION-bin.tar.gz" -o  "/tmp/apache-$HIVE_LIBRARY_VERSION-bin.tar.gz" \
    && tar -xf /tmp/apache-$HIVE_LIBRARY_VERSION-bin.tar.gz -C /usr/local && rm /tmp/apache-$HIVE_LIBRARY_VERSION-bin.tar.gz
ENV HIVE_HOME=/usr/local/apache-$HIVE_LIBRARY_VERSION-bin

# Install Apache Hadoop (Download same version of library to match EMR Hadoop version created by DAG)
RUN curl -f "https://archive.apache.org/dist/hadoop/common/$HADOOP_LIBRARY_VERSION/$HADOOP_LIBRARY_VERSION.tar.gz" -o "/tmp/$HADOOP_LIBRARY_VERSION.tar.gz" \
    && tar -xf /tmp/$HADOOP_LIBRARY_VERSION.tar.gz -C /usr/local && rm /tmp/$HADOOP_LIBRARY_VERSION.tar.gz
ENV HADOOP_HOME=/usr/local/$HADOOP_LIBRARY_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/conf

ENV PATH $PATH:$JAVA_HOME/bin::$HIVE_HOME/bin:$HADOOP_HOME/bin

COPY astronomer-providers /tmp/astronomer-providers
RUN pip install --no-cache-dir /tmp/astronomer-providers[all]
RUN pip install --no-cache-dir apache-airflow[slack]


RUN mkdir -p ${AIRFLOW_HOME}/dags
COPY . .
RUN cp -r example_* ${AIRFLOW_HOME}/dags
RUN cp master_dag.py  ${AIRFLOW_HOME}/dags/
RUN cp nuke-config.yml  ${AIRFLOW_HOME}/dags/

USER astro
