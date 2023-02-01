FROM java:8u91-jdk

ENV NIFI_VERSION=0.7.0
ENV NIFI_HOME=/nifi-$NIFI_VERSION

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Install Apache NiFi 0.7.0
RUN wget https://mirrors.koehn.com/apache/nifi/0.7.0/nifi-0.7.0-bin.tar.gz && tar -xzvf nifi-0.7.0-bin.tar.gz && rm nifi-0.7.0-bin.tar.gz
RUN rm /nifi-0.7.0-bin.tar.gz

# Exposes the needed baseline ports
EXPOSE 8080

# Startup NiFi
CMD $NIFI_HOME/bin/nifi.sh run