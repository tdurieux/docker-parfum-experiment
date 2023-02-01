FROM java:8u91-jdk

ENV NIFI_VERSION=0.3.0
ENV NIFI_HOME=/nifi-$NIFI_VERSION

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Install Apache NiFi 0.6.0
RUN wget https://archive.apache.org/dist/nifi/0.3.0/nifi-0.3.0-bin.tar.gz
RUN tar -xzvf nifi-0.3.0-bin.tar.gz && rm nifi-0.3.0-bin.tar.gz
RUN rm /nifi-0.3.0-bin.tar.gz

# Exposes the needed baseline ports
EXPOSE 8080

# Startup NiFi
CMD $NIFI_HOME/bin/nifi.sh run