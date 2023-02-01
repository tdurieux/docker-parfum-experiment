FROM java:8u91-jdk

ENV NIFI_VERSION=1.1.2
ENV NIFI_HOME=/nifi-$NIFI_VERSION

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Install Apache NiFi 1.1.2
RUN wget https://archive.apache.org/dist/nifi/1.1.2/nifi-1.1.2-bin.tar.gz && tar -xvzf nifi-1.1.2-bin.tar.gz && rm nifi-1.1.2-bin.tar.gz
RUN rm /nifi-1.1.2-bin.tar.gz

# Exposes the needed baseline ports
EXPOSE 8080

# Startup NiFi
CMD $NIFI_HOME/bin/nifi.sh run