FROM mesosphere/marathon-lb:latest

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg \
    && echo "deb http://debian.datastax.com/community stable main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list \
    && curl -f -L https://debian.datastax.com/debian/repo_key | apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        ruby \
        apache2 \
        vim \
        ruby-dev \
        build-essential \
        cassandra \
    && gem install --no-ri --no-rdoc cassandra-driver \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /marathon-lb

# NOTE(jkoelker) Clear out the entrypoint and cmd from the parent image
ENTRYPOINT []
CMD []
