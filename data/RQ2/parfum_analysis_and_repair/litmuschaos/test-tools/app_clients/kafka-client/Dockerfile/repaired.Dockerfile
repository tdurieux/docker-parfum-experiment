FROM confluentinc/cp-enterprise-kafka:5.4.6-3-deb8
RUN apt-get clean && \
    apt-get update --fix-missing || true && \
    apt-get install --no-install-recommends -y moreutils --force-yes && rm -rf /var/lib/apt/lists/*;
COPY topic.sh producer.sh consumer.sh /
