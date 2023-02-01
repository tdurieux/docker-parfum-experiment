FROM java:8
MAINTAINER Nilhcem

RUN DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y wget unzip && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.0.zip
RUN unzip -qq sonarqube-6.0.zip -d /opt/
RUN rm sonarqube-6.0.zip

EXPOSE 9000

CMD ["/opt/sonarqube-6.0/bin/linux-x86-64/sonar.sh", "console"]
