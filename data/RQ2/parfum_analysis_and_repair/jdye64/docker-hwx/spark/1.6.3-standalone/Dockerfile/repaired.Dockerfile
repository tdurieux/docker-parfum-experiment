FROM java:8u91-jdk

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Download and extract Apache Spark 1.6.2 without Hadoop
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-1.6.3-bin-hadoop2.6.tgz
RUN tar -xzvf spark-1.6.3-bin-hadoop2.6.tgz && rm spark-1.6.3-bin-hadoop2.6.tgz
RUN rm /spark-1.6.3-bin-hadoop2.6.tgz