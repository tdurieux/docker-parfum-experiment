FROM ubuntu:14.04

RUN sudo apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O - https://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
RUN echo "deb http://pkg.jenkins-ci.org/debian binary/" | sudo tee -a /etc/apt/sources.list
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y jenkins && rm -rf /var/lib/apt/lists/*;
