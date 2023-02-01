FROM java:8u91-jdk

ENV NIFI_VERSION=1.0.0
ENV NIFI_HOME=/nifi-$NIFI_VERSION-BETA

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Install Apache NiFi 1.0.0
RUN wget https://ftp.wayne.edu/apache/nifi/1.0.0-BETA/nifi-1.0.0-BETA-bin.tar.gz && tar -xzvf nifi-1.0.0-BETA-bin.tar.gz && rm nifi-1.0.0-BETA-bin.tar.gz
RUN rm /nifi-1.0.0-BETA-bin.tar.gz

# Exposes the needed baseline ports
EXPOSE 8080

# Startup NiFi
CMD $NIFI_HOME/bin/nifi.sh run