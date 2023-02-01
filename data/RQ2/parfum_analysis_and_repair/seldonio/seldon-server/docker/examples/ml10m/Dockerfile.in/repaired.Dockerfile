FROM seldonio/seldon-control:%SELDON_CONTROL_IMAGE_VERSION%

RUN \
    apt-get update && \
    apt-get -y --no-install-recommends -q install unzip && rm -rf /var/lib/apt/lists/*;

ADD attr.json /attr.json

ADD create_ml10m_recommender.sh /create_ml10m_recommender.sh

