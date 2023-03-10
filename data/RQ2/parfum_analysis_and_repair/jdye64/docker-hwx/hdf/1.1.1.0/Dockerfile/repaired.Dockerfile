FROM java:8u91-jdk

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Install Apache NiFi 0.6.1
RUN wget https://s3.amazonaws.com/public-repo-1.hortonworks.com/HDF/1.1.1.0/nifi-1.1.1.0-12-bin.zip
RUN unzip nifi-1.1.1.0-12-bin.zip
RUN rm nifi-1.1.1.0-12-bin.zip

# Exposes the needed baseline ports
EXPOSE 8080

# Startup NiFi
CMD /nifi-1.1.1.0-12/bin/nifi.sh run