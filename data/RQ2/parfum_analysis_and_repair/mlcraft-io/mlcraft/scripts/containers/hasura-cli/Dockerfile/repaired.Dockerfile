FROM hasura/graphql-engine:v2.0.7.cli-migrations-v3

RUN apt-get update -y && apt-get install --no-install-recommends -y curl socat && rm -rf /var/lib/apt/lists/*;

ADD start.sh .
