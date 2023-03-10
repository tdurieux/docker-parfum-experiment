FROM REPLACE_NULLWORKLOAD_UBUNTU

# java-install-pm
RUN apt-get update; apt install --no-install-recommends -y openjdk-8-jre:REPLACE_ARCH3 openjdk-8-jre-headless:REPLACE_ARCH3 openjdk-8-jdk:REPLACE_ARCH3 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt --fix-broken -y install
# java-install-pm

# hadoop-install-man
RUN wget -N -q -P /home/REPLACE_USERNAME https://archive.apache.org/dist/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz
RUN /bin/true; cd /home/REPLACE_USERNAME; sudo tar -xzf /home/REPLACE_USERNAME/hadoop*.gz
# hadoop-install-man

# hibench-install-git
RUN /bin/true; cd /home/REPLACE_USERNAME; git clone https://github.com/ibmcb/HiBench.git; cd /home/REPLACE_USERNAME/HiBench; git checkout dev
# hibench-install-git

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
