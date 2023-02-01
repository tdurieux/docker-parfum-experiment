FROM confluentinc/cp-kafka-connect:5.3.6
RUN apt update && apt -y --no-install-recommends --force-yes install jq bsdmainutils && rm -rf /var/lib/apt/lists/*;
COPY check.sh /work/check.sh
COPY create_topics.sh /work/create_topics.sh
COPY create_connectors.sh /work/create_connectors.sh
COPY connect-cli /usr/bin/connect-cli
COPY /connectors/ /work/connectors/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
