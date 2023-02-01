FROM java:8u91-jdk

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Download and extract Apache Spark 2.0.0 without Hadoop
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz
RUN tar -xzvf spark-2.0.0-bin-hadoop2.7.tgz && rm spark-2.0.0-bin-hadoop2.7.tgz
RUN rm /spark-2.0.0-bin-hadoop2.7.tgz