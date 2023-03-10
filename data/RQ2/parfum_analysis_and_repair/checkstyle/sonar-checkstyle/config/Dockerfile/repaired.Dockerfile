FROM sonarqube:7.9-community

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

USER root

# circleci need home folder to be present and accessible by execution user
RUN mkdir /home/sonarqube && chown sonarqube:sonarqube /home/sonarqube

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL https://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

VOLUME "$USER_HOME_DIR/.m2"

# update dpkg repositories to be able to install packages
RUN apt-get -y update \
  && apt-get install --no-install-recommends -y git \
  && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

USER sonarqube

# Build image by "docker build -t sonarqube-maven-git ."
# run it as "docker run -d --name sonarqube-maven-git -p 9000:9000 -p 9092:9092 sonarqube-maven-git"
# step inside "docker exec -i -t sonarqube-maven-git /bin/bash"
