# © Copyright IBM Corporation 2018, 2019.
# LICENSE: GPL v3 license, Version 3 (http://www.gnu.org/licenses)

########## Dockerfile for Neo4j version 3.5.6 ##################################
#
# This Dockerfile builds a basic installation of Neo4j.
#
# Neo4j is the world's leading Graph Database.Neo4j is available both as a standalone server, or an embeddable component.  
# It is a high performance graph store with all the features expected of a mature and robust database, like a friendly query language and ACID transactions.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# To simply run the resultant image, and provide a bash shell:
# docker run -it <image_name> /bin/bash
# 
# Use the following command to start neo4j server :
# docker run --name <container_name> -d -p <host-port>:<container-port> <image-name>
#
# Provide custom configuration file
# docker run --name <container_name> -d -p <host-port>:<container-port> -v /<path_on_host>/neo4j.conf:/root/neo4j/conf/neo4j.conf <image-name> 
#  
# Official website: https://neo4j.com/
#
##################################################################################

#Base Image
FROM s390x/ubuntu:16.04

# The author
LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"

ARG NEO4J_VER=3.5.6
ENV SOURCE_DIR='/root'
ENV NEO4J_HOME=$SOURCE_DIR/neo4j
ENV JAVA_HOME=$SOURCE_DIR/jdk-11.0.3+7
ENV PATH=$PATH:$NEO4J_HOME/bin:$JAVA_HOME/bin

WORKDIR $SOURCE_DIR

# Install dependencies
RUN  apt-get update  \
  && apt-get install -y  \
                tar \
                wget \
# Download adoptopenjdk
  && cd $SOURCE_DIR/ \
  && wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.3%2B7_openj9-0.14.3/OpenJDK11U-jdk_s390x_linux_openj9_11.0.3_7_openj9-0.14.3.tar.gz \
  && tar -zxf OpenJDK11U-jdk_s390x_linux_openj9_11.0.3_7_openj9-0.14.3.tar.gz \
# Download and unzip Neo4j pre build Binary
  && cd $SOURCE_DIR/ \
  && wget https://neo4j.com/artifact.php?name=neo4j-community-${NEO4J_VER}-unix.tar.gz \
  && tar -xvzf artifact.php?name=neo4j-community-${NEO4J_VER}-unix.tar.gz \
  && mv neo4j-community-${NEO4J_VER} neo4j \
# Clean up the unwanted packages and clear the source directory
  && apt-get remove -y \
                wget  \
  && apt-get autoremove -y \
  && apt autoremove -y \
  && apt-get clean \
  && rm -rf $SOURCE_DIR/OpenJDK11U-jdk_s390x_linux_openj9_11.0.3_7_openj9-0.14.3.tar.gz $SOURCE_DIR/artifact.php?name=neo4j-community-${NEO4J_VER}-unix.tar.gz /var/lib/apt/lists/*

# Define mount for backup of logs, data, conf & lib
VOLUME ["$NEO4J_HOME/logs","$NEO4J_HOME/data","$NEO4J_HOME/conf","$NEO4J_HOME/lib"]

# Port for Neo4j
EXPOSE 7474 7473 6362 5000 6000 7000 5001 6001 2003 3637 1337

# Set the Entrypoint
CMD ["neo4j","console"]

# End of Dockerfile
