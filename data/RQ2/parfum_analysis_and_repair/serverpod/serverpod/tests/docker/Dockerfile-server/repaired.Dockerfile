# Specify the Dart SDK base image version
FROM dart:2.14 AS build

# Install psql client.
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

# Set the working directory
WORKDIR /app

# Copy the whole serverpod repo into the container.
COPY . .

# Install dependencies for test server.
WORKDIR tests/serverpod_test_server
RUN dart pub get

# Setup database tables and start the server.
CMD ["../docker/start-server.sh"]
