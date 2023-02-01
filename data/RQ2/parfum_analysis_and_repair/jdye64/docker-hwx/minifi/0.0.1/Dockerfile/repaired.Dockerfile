FROM java:8u91-jdk

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Install Apache minifi 0.0.1
RUN wget https://apache.spinellicreations.com/nifi/minifi/0.0.1/minifi-0.0.1-bin.tar.gz
RUN tar -xzvf minifi-0.0.1-bin.tar.gz && rm minifi-0.0.1-bin.tar.gz

# Startup NiFi
CMD /minifi-0.0.1/bin/minifi.sh run