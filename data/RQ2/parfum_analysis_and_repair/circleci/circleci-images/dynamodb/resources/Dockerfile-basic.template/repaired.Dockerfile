FROM {{BASE_IMAGE}}

# It's DynamoDB, in Docker!
#
# Check for details on how to run DynamoDB locally.:
#
# http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html
#
# This Dockerfile essentially replicates those instructions.

# Create our main application folder.
RUN mkdir -p opt/dynamodb
WORKDIR /opt/dynamodb

# Download and unpack dynamodb.
RUN wget https://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz -q -O - | tar -xz || curl -f -L https://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | tar xz

# The entrypoint is the dynamodb jar.
ENTRYPOINT ["java", "-Xmx1G", "-jar", "DynamoDBLocal.jar"]

# Default port for "DynamoDB Local" is 8000.
EXPOSE 8000
