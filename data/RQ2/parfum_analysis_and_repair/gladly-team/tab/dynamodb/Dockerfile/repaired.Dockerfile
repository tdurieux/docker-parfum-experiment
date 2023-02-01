FROM ubuntu:20.04

RUN mkdir /opt/dynamodb
RUN mkdir /opt/dynamodb/db

WORKDIR /opt/dynamodb

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  default-jre \
  wget && rm -rf /var/lib/apt/lists/*;

RUN wget -O /tmp/dynamodb https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz
RUN tar xfz /tmp/dynamodb

# Install Node.
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["java", "-Djava.library.path=.", "-jar", "/opt/dynamodb/DynamoDBLocal.jar", "-dbPath", "/opt/dynamodb/db", "-sharedDb"]
CMD ["-port", "8000"]

VOLUME ["/opt/dynamodb/db"]

EXPOSE 8000

RUN mkdir /dynamodb
WORKDIR /dynamodb
