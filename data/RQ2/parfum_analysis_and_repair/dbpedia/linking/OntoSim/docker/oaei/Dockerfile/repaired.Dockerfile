# Docker for oaei
### Get Linux
FROM ubuntu:18.04

RUN apt-get update
RUN apt-get update -y


# Install supervisor START

# supervisor for multiple process
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
ADD supervisord_oaei.conf /etc/supervisor/conf.d/supervisord.conf

# Install supervisor END

# install netstat
RUN apt-get install -y --no-install-recommends net-tools && rm -rf /var/lib/apt/lists/*;

# install grep
RUN apt-get install -y --no-install-recommends grep && rm -rf /var/lib/apt/lists/*;

# Install wget
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;


# Install java START

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

# Fix certificate issues
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f; rm -rf /var/lib/apt/lists/*;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

# Install java END

# Install maven START

# get maven 3.3.9
RUN wget --no-verbose -O /tmp/apache-maven-3.3.9.tar.gz https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

# install maven
RUN tar xzf /tmp/apache-maven-3.3.9.tar.gz -C /opt/ && rm /tmp/apache-maven-3.3.9.tar.gz
RUN ln -s /opt/apache-maven-3.3.9 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.3.9.tar.gz
ENV MAVEN_HOME /opt/maven

# Install maven END

# remove download archive files
RUN apt-get clean

#CREATE TMP FILE for java
RUN mkdir -p /usr/ontosim/java/
WORKDIR /usr/ontosim/java/
ADD /linking_java/OntoSimilarity /usr/ontosim/java/

# BUILDING maven START

RUN mvn -v
RUN mvn clean install -Pbatch

RUN cp /usr/ontosim/java/target/OntoSimilarity.jar /usr/ontosim/OntoSimilarity.jar
RUN rm -rf /usr/ontosim/java/*

RUN cp /usr/ontosim/OntoSimilarity.jar /usr/ontosim/java/OntoSimilarity.jar

# BUILDING maven END


ADD /linking_java/ontofiles /usr/ontosim/java/ontofiles
ADD /joaei_process.sh /usr/ontosim/java/joaei_process.sh


# Install python START

RUN apt-get install --no-install-recommends -y python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /

#CREATE TMP FOLDER for python
RUN mkdir -p /usr/ontosim/python/

ADD /linking_python/requirements.txt /usr/ontosim/python/requirements.txt
ADD /linking_python/OntoSimPY/ /usr/ontosim/python/OntoSimPY
ADD /linking_python/py_model/model/ /usr/ontosim/python/model


RUN pip3 install --no-cache-dir -r /usr/ontosim/python/requirements.txt
RUN [ "python3", "-c", "import nltk; nltk.download('wordnet')" ]

# Install python END

EXPOSE 5000

CMD ["supervisord"]
