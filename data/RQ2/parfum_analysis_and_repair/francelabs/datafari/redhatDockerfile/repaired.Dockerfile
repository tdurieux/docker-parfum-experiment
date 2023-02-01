FROM centos:centos7 AS BUILD

ENV MAVEN_VERSION=3.6.3
ENV BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV USER_HOME_DIR=/root
ENV ANT_VERSION=1.10.3
ENV ANT_HOME=/opt/ant

# Temporary Workaround to Surefire issue
ENV _JAVA_OPTIONS=-Djdk.net.URLClassPath.disableClassPathURLCheck=true

# change to tmp folder
WORKDIR /tmp



# Update
RUN yum update -y
# Get Java
RUN yum install java-1.8.0-openjdk-devel -y && rm -rf /var/cache/yum
# Get dependencies
RUN yum install centos-release-scl -y && rm -rf /var/cache/yum
RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install sclo-cassandra3-jffi -y && rm -rf /var/cache/yum
RUN yum install python27 -y && rm -rf /var/cache/yum
#scl enable python27 bash
RUN source /etc/profile
RUN yum install jq -y && rm -rf /var/cache/yum
RUN yum install lsof -y && rm -rf /var/cache/yum
RUN yum groupinstall "Development tools" -y
RUN yum install curl -y && rm -rf /var/cache/yum
RUN yum install perl-Test-Simple perl-version perl-Data-Dumpe -y && rm -rf /var/cache/yum
RUN yum install dpkg-devel dpkg-dev -y && rm -rf /var/cache/yum
RUN yum install httpd -y && rm -rf /var/cache/yum
RUN yum install mod_ssl -y && rm -rf /var/cache/yum
RUN yum install nano -y && rm -rf /var/cache/yum
RUN yum install wget -y && rm -rf /var/cache/yum

ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
# Download and extract maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Download and extract apache ant to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.sha512 \
    && echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.sha512) apache-ant-${ANT_VERSION}-bin.tar.gz" | sha512sum -c \
    && tar -zxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz.sha512

# add executables to path
RUN update-alternatives --install "/usr/bin/ant" "ant" "/opt/ant/bin/ant" 1 && \
    update-alternatives --set "ant" "/opt/ant/bin/ant"

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

WORKDIR ./datafari
COPY . .
RUN mvn -f pom.xml -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -B clean install
RUN ant clean-build -f ./linux/build.xml

RUN mkdir /root/rpmbuild
RUN mv linux/installer/redhat/* /root/rpmbuild
RUN cd /root/rpmbuild/SPECS && rpmbuild -ba datafari.spec
RUN mv /root/rpmbuild/RPMS/x86_64/datafari*.rpm /root/datafari.rpm

FROM centos/systemd AS deploy

MAINTAINER Olivier Tavard FRANCE LABS <olivier.tavard@francelabs.com>

# Update
RUN yum update -y
# Get Java
RUN yum install java-1.8.0-openjdk-devel -y && rm -rf /var/cache/yum
# Get dependencies
RUN yum install centos-release-scl -y && rm -rf /var/cache/yum
RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install sclo-cassandra3-jffi -y && rm -rf /var/cache/yum
RUN yum install python27 -y && rm -rf /var/cache/yum
#scl enable python27 bash
RUN source /etc/profile
RUN yum install jq -y && rm -rf /var/cache/yum
RUN yum install lsof -y && rm -rf /var/cache/yum
RUN yum groupinstall "Development tools" -y
RUN yum install curl -y && rm -rf /var/cache/yum
RUN yum install perl-Test-Simple perl-version perl-Data-Dumpe -y && rm -rf /var/cache/yum
RUN yum install dpkg-devel dpkg-dev -y && rm -rf /var/cache/yum
RUN yum install httpd -y && rm -rf /var/cache/yum
RUN yum install mod_ssl -y && rm -rf /var/cache/yum
RUN yum install nano -y && rm -rf /var/cache/yum
RUN yum install wget -y && rm -rf /var/cache/yum
RUN yum install sudo -y && rm -rf /var/cache/yum

ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0

# For dev
RUN echo "export LANG=C.UTF-8" >> /etc/profile
RUN echo "export JAVA_HOME=/usr/local/openjdk-8" >> /etc/profile
RUN echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile

WORKDIR /var/datafari
COPY --from=BUILD /root/datafari.rpm .
RUN rpm -ivh datafari.rpm

EXPOSE 80 443
WORKDIR /opt/datafari
RUN  sed -i -e 's/sleep 10/sleep 30/g' /opt/datafari/bin/start-datafari.sh
RUN systemctl enable httpd
CMD ["/usr/sbin/init"]

