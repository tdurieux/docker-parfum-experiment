FROM java:8u91-jdk

# Update apt-get repository
RUN apt-get update && apt-get install --no-install-recommends -y unzip ant git vim && rm -rf /var/lib/apt/lists/*; # Install system dependencies


# Download and extract Apache Spark 2.0.1 without Hadoop
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz
RUN tar -xzvf park-2.0.1-bin-hadoop2.7.tgz && rm park-2.0.1-bin-hadoop2.7.tgz
RUN rm /park-2.0.1-bin-hadoop2.7.tgz