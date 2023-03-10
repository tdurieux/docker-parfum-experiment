FROM ubuntu:18.04

WORKDIR /app

# Install wget and Java 11
RUN apt-get update && apt-get install --no-install-recommends wget default-jre -y && rm -rf /var/lib/apt/lists/*;

# Download and untar the jar file
RUN wget https://www.cs.cmu.edu/~alavie/METEOR/download/meteor-1.5.tar.gz && \
    tar xzvf meteor-1.5.tar.gz && \
    rm meteor-1.5.tar.gz