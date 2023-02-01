# © Copyright IBM Corporation 2017, 2019.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)

################################ Dockerfile for Scala version 2.13.0 #############################################################
# This Dockerfile builds a basic installation of Scala.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# Start Scala container using the below command
# docker run --name <container_name> -v <source path>/file.scala:/file.scala -d <image_name> scala file.scala -o file
# Example: docker run --name scala_new -v /HelloWorld.scala:/HelloWorld.scala -d scala_img_ub scala HelloWorld.scala -o HelloWorld
#
#########################################################################################################################

# Base Image
FROM s390x/ubuntu:16.04

# The Author
LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"

# Install build Dependencies 
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    wget \
# Install Scala    
 && wget http://www.scala-lang.org/files/archive/scala-2.13.0.deb \
 && dpkg -i scala-2.13.0.deb \
 
# Clean up data and unused packages
 && apt-get remove -y wget \
 && apt-get autoremove -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && rm -rf /root/scala-2.13.0.deb

CMD ["scala","-version"]

# End of Dockerfile
