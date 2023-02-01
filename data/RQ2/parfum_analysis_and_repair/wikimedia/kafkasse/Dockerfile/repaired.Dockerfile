FROM debian:stretch
MAINTAINER jobar <joseph.allemandou@gmail.com>

# Needed to prevent apt errors with debian image
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#    apt-get install -y apt-utils

ENV NODE_VERSION "8.x"

# Install needed packages:
# NOTE: librdkafka 0.11 is built and tested against libssl1.0.  1.1 causes a segfault.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y build-essential curl g++ net-tools libsasl2-dev libssl1.0-dev libcrypto++-dev && rm -rf /var/lib/apt/lists/*;

# Install node
RUN curl -f -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Copy KafkaSSE code to /src/KafkaSSE
RUN mkdir -p /src/KafkaSSE
WORKDIR /src/KafkaSSE
COPY lib ./lib
COPY test ./test
COPY .travis.yml ./.travis.yml
COPY *.* ./

# Install KafkaSSE dependencies
RUN npm install && npm cache clean --force;

# Use this broker address for tests in docker.
ENV KAFKA_BROKERS='kafka:9092'

# Exec command: run test coverage
CMD ["npm", "run", "coverage"]
