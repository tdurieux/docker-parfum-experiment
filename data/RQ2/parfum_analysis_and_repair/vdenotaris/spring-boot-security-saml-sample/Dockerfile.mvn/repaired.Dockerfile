############################################################################
#                                                                          #
# Copyright 2021 Vincenzo De Notaris                                       #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  #
#                                                                          #
#     http://www.apache.org/licenses/LICENSE-2.0                           #
#                                                                          #
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
# See the License for the specific language governing permissions and      #
# limitations under the License.                                           #
#                                                                          #
############################################################################

# Use Maven to complile and run
FROM maven:3.6.2-jdk-8

# Project maintainer
LABEL maintainer="dev@vdenotaris.com"

# Upgrade Alpine packages and install OpenSSL
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install openssl && rm -rf /var/lib/apt/lists/*;

# Add a volume pointing to /tmp
VOLUME /tmp

# Create the app directory
RUN mkdir -p usr/src/app/

# Copy the source code
COPY src /usr/src/app/src 
COPY pom.xml /usr/src/app

# Retrieve a fresh SSO Circle's certificate and store it within the application keystore
RUN chmod +x /usr/src/app/src/main/resources/saml/update-certifcate.sh
RUN cd /usr/src/app/src/main/resources/saml/ && sh ./update-certifcate.sh

# Setup Mavem
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xmx1024m"
ENV MAVEN_CONFIG=/var/maven/.m2

# Setup working directory
WORKDIR /usr/src/app

# Compile and run the application (it will take a bit of time)
ENTRYPOINT ["mvn","spring-boot:run","-Duser.home=/var/maven"] 

############################################################################
