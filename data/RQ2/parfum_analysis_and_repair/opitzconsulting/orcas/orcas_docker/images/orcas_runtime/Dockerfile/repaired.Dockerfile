# image with sqlplus(from base image), ant, java and gradle installed
FROM wnameless/oracle-xe-11g

RUN apt-get -y update && apt-get install --no-install-recommends -y \
  ant \
  ant-contrib \
  default-jdk \
  unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

# install gradle
ENV gradle_version=2.1
RUN wget -Nnv https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip \
 && unzip gradle-${gradle_version}-all.zip -d /opt/gradle \
 && ln -sfn gradle-${gradle_version} /opt/gradle/latest

ENV GRADLE_HOME=/opt/gradle/latest
ENV ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
ENV PATH=$PATH:$GRADLE_HOME/bin:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib

RUN mvn install:install-file "-Dfile=/u01/app/oracle/product/11.2.0/xe/jdbc/lib/ojdbc6.jar" -DgroupId=com.oracle -DartifactId=ojdbc6 -Dversion=11.1.0.7 -Dpackaging=jar

