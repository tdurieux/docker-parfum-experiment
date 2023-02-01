FROM zenika/kotlin:1.3.10-jdk11-slim as builder

# Create workdir
RUN mkdir -p /tmp
WORKDIR /tmp

# Install deps
RUN apt update && \
  apt install -y wget && \
  apt clean && \
  apt autoremove

# Download dumb-init
RUN wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64

# Copy
COPY . .

# Give execution perms && and build
RUN chmod +x /tmp/gradlew && \
  /tmp/gradlew --no-daemon :kafka-streams:assemble

FROM zenika/kotlin:1.3.10-jdk11-slim

COPY --from=builder /tmp/kafka-streams/build/distributions/kafka-streams-1.0.0.tar /
COPY --from=builder /dumb-init /usr/bin/dumb-init

# Prepare binary
RUN tar -xvf kafka-streams-1.0.0.tar && \
  mv kafka-streams-1.0.0 /usr/bin/kafka-streams && \
  chmod +x /usr/bin/kafka-streams/bin/kafka-streams && \
  chmod +x /usr/bin/dumb-init && \
  rm -rf kafka-streams-1.0.0.tar

VOLUME ["/var/lib/kafka-streams"]

# Define entry
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Define cmd
CMD ["/usr/bin/kafka-streams/bin/kafka-streams"]
