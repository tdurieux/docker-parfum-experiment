### This dockerfile contains the complete process of downloading / building / executing the application

FROM ubuntu:17.04

MAINTAINER "Marco Molteni <moltenma@gmail.com>"

RUN apt-get -y update

RUN apt-get -y --no-install-recommends install curl openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git wget && rm -rf /var/lib/apt/lists/*;

### maven : begin

RUN wget --no-verbose -O /tmp/apache-maven-3.5.0.tar.gz https://archive.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz

# verify checksum
RUN echo "35c39251d2af99b6624d40d801f6ff02 /tmp/apache-maven-3.5.0.tar.gz" | md5sum -c

RUN tar xzf /tmp/apache-maven-3.5.0.tar.gz -C /opt/ && rm /tmp/apache-maven-3.5.0.tar.gz
RUN ln -s /opt/apache-maven-3.5.0 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.0.tar.gz
ENV MAVEN_HOME /opt/maven

### maven : end


# set the path of the working dir
RUN mkdir /usr/src/myapp && rm -rf /usr/src/myapp
WORKDIR /usr/src/myapp

# install node.js
RUN curl -f -sL curl -sL https://deb.nodesource.com/setup_8.x | bash -

# https://docs.npmjs.com/getting-started/fixing-npm-permissions
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# clone the repository with the code
RUN git clone -b master git://github.com/marco76/spriNGdemo.git

# install npm modules
WORKDIR /usr/src/myapp/spriNGdemo/client/src
RUN npm install --unsafe-perm -g @angular/cli && npm cache clean --force;
RUN npm rebuild node-sass --force
WORKDIR /usr/src/myapp/spriNGdemo
RUN mvn generate-resources install
RUN chmod 777 /tmp

RUN yes | cp -rf /usr/src/myapp/spriNGdemo/server/target/server-0.0.4-SNAPSHOT.war /usr/src/myapp

CMD ["java", "-jar", "/usr/src/myapp/server-0.0.4-SNAPSHOT.war"]

####
# build with:
# docker build -t javaee/springdemo .
#
# run with:
# docker run --rm -it -p 80:8080  javaee/springdemo