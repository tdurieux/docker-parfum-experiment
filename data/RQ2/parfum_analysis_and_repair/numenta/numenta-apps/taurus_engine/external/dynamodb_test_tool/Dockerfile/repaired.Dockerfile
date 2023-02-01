FROM numenta/nupic:latest
RUN apt-get install --no-install-recommends -y default-jre-headless && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/.dynamodb
WORKDIR /root
RUN wget -qO- https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz | /bin/tar xz
EXPOSE 8300
ENV DYNAMODB_PORT 8300
CMD java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -port ${DYNAMODB_PORT} -sharedDb -dbPath /root/.dynamodb
