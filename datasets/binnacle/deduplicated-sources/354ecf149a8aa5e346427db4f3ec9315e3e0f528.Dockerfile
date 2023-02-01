FROM pipelineai/ubuntu-16.04-cpu:1.5.0

###################################################################################
# Unless you have a special case, you shouldn't be building from this Dockerfile.
# Please see http://pipeline.ai/api for more details.
###################################################################################

WORKDIR /root

RUN \
  mkdir -p /root/logs

ENV \
  LOGS_HOME=/root/logs

COPY sysutils/ sysutils/

ENV \
  CONFLUENT_VERSION=5.0.0 \
  CONFLUENT_MAJOR_VERSION=5.0

ENV \
  CONFLUENT_HOME=/root/confluent-${CONFLUENT_VERSION}

ENV \
  PATH=$CONFLUENT_HOME/bin:$PATH

RUN \
 wget http://packages.confluent.io/archive/${CONFLUENT_MAJOR_VERSION}/confluent-oss-${CONFLUENT_VERSION}-2.11.tar.gz \
 && tar xvzf confluent-oss-${CONFLUENT_VERSION}-2.11.tar.gz \
 && rm confluent-oss-${CONFLUENT_VERSION}-2.11.tar.gz

ENV \
  PATH=$PATH:/root/confluent-oss-${CONFLUENT_VERSION}-2.11/bin

RUN \
  git clone https://github.com/edenhill/librdkafka.git \
  && cd librdkafka \
  && ./configure \
  && make \
  && make install

RUN \
  pip install git+https://github.com/wintoncode/winton-kafka-streams.git

# Must run ths or you will see the following error:
#   ImportError: librdkafka.so.1: cannot open shared object file: No such file or directory
RUN \
  ldconfig

# Install Mosquitto MQTT Broker
RUN \
  apt-get update \
  && apt-get install -y mosquitto \
  && apt-get install -y mosquitto-clients

COPY jvm/ jvm/
COPY scripts/ scripts/
COPY config/ config/
COPY run run

# Don't forget to update the pipeline cli if these ports change!
EXPOSE \
#  # Kafka Broker \
  9092 \
  # Kafka REST API \
  8082 \
  # Kafka Schema Manager \
  8081 \
  # ZooKeeper \
  2181 \
  # Mosquitto MQTT \
  1883

# Executes the ./run script upon startup
CMD ["supervise", "."]
