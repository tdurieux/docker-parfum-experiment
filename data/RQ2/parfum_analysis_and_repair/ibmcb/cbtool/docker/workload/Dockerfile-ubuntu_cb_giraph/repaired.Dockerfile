FROM REPLACE_NULLWORKLOAD_UBUNTU

# java-install-pm
RUN apt-get update; apt install --no-install-recommends -y openjdk-8-jre:REPLACE_ARCH3 openjdk-8-jre-headless:REPLACE_ARCH3 openjdk-8-jdk:REPLACE_ARCH3 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt --fix-broken -y install
# java-install-pm

# hadoop-install-man
RUN sudo wget -N -q -P /home/REPLACE_USERNAME https://archive.apache.org/dist/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
#RUN wget -N -q -P /home/REPLACE_USERNAME https://archive.apache.org/dist/hadoop/common/hadoop-2.3.0/hadoop-2.3.0.tar.gz
RUN /bin/true; cd /home/REPLACE_USERNAME; sudo tar -xzf /home/REPLACE_USERNAME/hadoop*.gz
# hadoop-install-man

# maven-install-pm
RUN apt-get install --no-install-recommends -y maven ant && rm -rf /var/lib/apt/lists/*;
# maven-install-pm

# giraph-install-git
RUN sudo chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
RUN /bin/true; cd /home/REPLACE_USERNAME; git clone https://github.com/apache/giraph.git
RUN /bin/true; export JAVA_HOME=/usr/lib/jvm/$(ls -t /usr/lib/jvm | grep java | sed '/^$/d' | sort -r | head -n 1)/jre; cd /home/REPLACE_USERNAME/giraph/; git checkout release-1.0.0;
RUN cd /home/REPLACE_USERNAME/giraph/; sudo sed -i 's^http://repo1.maven.org/maven2^https://repo.maven.apache.org/maven2^g' pom.xml; mvn package -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2,SSLv3 -Phadoop_1.0 -DskipTests; /bin/true
#RUN /bin/true; cd /home/REPLACE_USERNAME/giraph/; git checkout release-1.1; mvn package -Phadoop_yarn -Dhadoop.version=2.3.0 -DskipTests
# giraph-install-git

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
