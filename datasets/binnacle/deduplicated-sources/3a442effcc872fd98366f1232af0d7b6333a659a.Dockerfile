# © Copyright IBM Corporation 2017, 2019.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)

############################ Dockerfile for Logstash version 7.0.1 ###################################################
#
# This Dockerfile builds a basic installation of Logstash
#
# Logstash is a tool for managing events and logs. When used generically the term
# encompasses a larger system of log collection, processing, storage and searching activities.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# Start Logstash using the below command
# docker run --name <container name> -v <path_on_host>/logstash.conf:/etc/logstash/logstash.conf -d <logstash_image>
#######################################################################################################################

# Base image
FROM s390x/ubuntu:16.04

ARG LOGSTASH_VER=7.0.1

# The author
LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"

WORKDIR "/root"
ENV JAVA_HOME=/root/jdk8u202-b08/
ENV PATH=$JAVA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=/root/jffi-jffi-1.2.18/build/jni/:$LD_LIBRARY_PATH
# Install dependencies
RUN apt-get update && apt-get install -y \
    ant \
    gcc \
    make \
    tar \
    unzip \
    zip \
    wget \

# Download OpenJDK8 with Eclipse OpenJ9
 && wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08_openj9-0.12.1/OpenJDK8U-jdk_s390x_linux_openj9_8u202b08_openj9-0.12.1.tar.gz \
 && tar -xf OpenJDK8U-jdk_s390x_linux_openj9_8u202b08_openj9-0.12.1.tar.gz \

# Download the logstash source from github and build it
 && wget https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VER}.zip \
 && unzip -u logstash-${LOGSTASH_VER}.zip \
 && wget https://github.com/jnr/jffi/archive/jffi-1.2.18.zip \
 && unzip -u jffi-1.2.18.zip  && cd jffi-jffi-1.2.18 && ant && cd .. \
 && cp -r /root/logstash-${LOGSTASH_VER} /usr/share/logstash \

# Copy types.conf to platform.conf, re-create and copy the jar
 && cd /usr/share/logstash/logstash-core/lib/jars \
 && unzip -d jruby-complete-9.2.7.0.jar-dir jruby-complete-9.2.7.0.jar \
 && cd /usr/share/logstash/logstash-core/lib/jars/jruby-complete-9.2.7.0.jar-dir/META-INF/jruby.home/lib/ruby/stdlib/ffi/platform/s390x-linux \
 && cp -n types.conf platform.conf \
 && cd /usr/share/logstash/logstash-core/lib/jars/jruby-complete-9.2.7.0.jar-dir \
 && zip -r jruby-complete-9.2.7.0.jar * \
 && mv -f jruby-complete-9.2.7.0.jar .. \
 && rm -rf /usr/share/logstash/logstash-core/lib/jars/jruby-complete-9.2.7.0.jar-dir \
 && cd /root \
 
# Cleanup Cache data , unused packages and source files
 && apt-get remove -y \
    ant \
    make \
    unzip \
    wget \
 && apt-get autoremove -y && apt-get clean \
 && rm -rf /root/logstash-${LOGSTASH_VER} \
 && rm /root/logstash-${LOGSTASH_VER}.zip \
 && rm /root/jffi-1.2.18.zip \
 && rm -rf /var/lib/apt/lists/*

# Define mountable directory
VOLUME ["/data"]

# Expose ports
EXPOSE 514 5043 5000 9292

ENV PATH=/usr/share/logstash/bin:$PATH

CMD ["logstash", "-f", "/etc/logstash/logstash.conf"]
# End of Dockerfile
