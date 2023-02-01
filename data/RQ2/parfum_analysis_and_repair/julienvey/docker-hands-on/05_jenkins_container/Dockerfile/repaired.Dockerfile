FROM ubuntu

# Install packages needed
RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-6-jdk git curl maven wget && rm -rf /var/lib/apt/lists/*;

# Install Jenkins
RUN wget -q -O - https://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update
RUN apt-get install --no-install-recommends -y jenkins && rm -rf /var/lib/apt/lists/*;

# Copy SSH Key
ADD docker.pub /root/.ssh/id_rsa.pub
ADD docker /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
ADD ssh-config /etc/ssh/ssh_config

# Configure Jenkins
ADD jenkinsconf.tar.gz /root
RUN chmod 700 /root/.jenkins
ADD startup-jenkins.sh /startup.sh
RUN chmod 700 /startup.sh

EXPOSE 8080

CMD /startup.sh
