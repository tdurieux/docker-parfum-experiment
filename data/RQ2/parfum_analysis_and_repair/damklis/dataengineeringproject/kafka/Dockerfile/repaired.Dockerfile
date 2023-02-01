FROM confluentinc/cp-kafka:5.3.5

ENV KAFKA_CONFLUENT_SUPPORT_METRICS_ENABLE "false"
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR "1"
ENV KAFKA_HEAP_OPTS "-Xmx512m -Xms512m"

ADD create_default_topic.sh .

RUN apt-get update \
&& apt-get install --no-install-recommends --force-yes -y net-tools \
&& chmod +x ./create_default_topic.sh && rm -rf /var/lib/apt/lists/*;

CMD [ "./create_default_topic.sh" ]
