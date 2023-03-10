FROM ubuntu:16.04 AS builder
#maven:3-jdk-8 AS builder
ARG rainbow_version=SWIM1.0
RUN apt update && apt-get install --no-install-recommends -y software-properties-common zip unzip tar gzip libboost-all-dev libyaml-cpp-dev make automake autoconf g++ ant wget libpcre3-dev socat swig curl bash git-core && rm -rf /var/lib/apt/lists/*;

# To ensure the right versions of the libraries in the build
# we need to FROM the same root, so that means installing Java
# and Maven manually

RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Install Maven
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven && \
 curl -fsSL https://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# Install pladapt
WORKDIR /root/
RUN git clone https://github.com/cps-sei/pladapt.git

WORKDIR /root/pladapt
RUN reach/build.sh

RUN autoreconf -fvi && \
    mkdir build && \
    cd build && \
    ../configure && \
    make

WORKDIR /root/pladapt/java
### Bug fix to get around the fact that uname returns unknown for maven:3-jdk-8
RUN sed 's/$(shell uname -i)/x86_64/' Makefile > Makefile-bugfix && \
    make -f Makefile-bugfix mvn-install
# RUN  make mvn-install
#RUN mvn install:install-file -Dfile=pladapt_wrap.jar -DgroupId=pladapt -DartifactId=pladapt_wrap -Dversion=1.0.1 -Dpackaging=jar
# Install Hogna and Opera
COPY deployments/rainbow-swim/deps .
RUN unzip hogna.zip libs/Hogna.jar libs/Opera.jar && \
    mvn install:install-file -Dfile=libs/Hogna.jar -DgroupId=opera -DartifactId=hogna -Dversion=1.0 -Dpackaging=jar && \
    mvn install:install-file -Dfile=libs/Opera.jar -DgroupId=opera -DartifactId=opera -Dversion=1.0 -Dpackaging=jar

ADD deployments /root/rainbow/deployments
ADD libs /root/rainbow/libs
ADD ide /root/rainbow/ide
ADD rainbow /root/rainbow/rainbow
ADD targets /root/rainbow/targets
ADD license.html /root/rainbow
ADD build.sh /root/rainbow
ADD scripts /root/rainbow/scripts
WORKDIR /root/rainbow
RUN ls
RUN  ./build.sh -s -d rainbow-swim -t swim i-v${rainbow_version} install
CMD [/bin/bash]

FROM gabrielmoreno/swim:1.0
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install software-properties-common dbus dbus-x11 xorg xserver-xorg-legacy xinit xterm libboost-all-dev libyaml-cpp-dev libpcre3-dev socat && rm -rf /var/lib/apt/lists/*;

RUN sed -i "s/allowed_users=console/allowed_users=anybody/;$ a needs_root_rights=yes" /etc/X11/Xwrapper.config

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java8-installer --allow-unauthenticated && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN mkdir /rainbow
WORKDIR /rainbow
COPY --from=builder /root/pladapt ./pladapt
ENV PLADAPT /rainbow/pladapt
COPY --from=builder /root/rainbow/Rainbow-build .
RUN echo "export SOCAT_PORT=4242" >> /headless/.bashrc
COPY deployments/rainbow-swim/docker/rainbow.png /headless/
COPY deployments/rainbow-swim/docker/SWIM.png /headless/
COPY deployments/rainbow-swim/docker/Rainbow.desktop /headless/Desktop
COPY deployments/rainbow-swim/docker/SWIM.desktop /headless/Desktop
RUN chmod +x /headless/Desktop/Rainbow.desktop /headless/Desktop/SWIM.desktop
#ENTRYPOINT ["./rainbow-oracle.sh", "swim"]
