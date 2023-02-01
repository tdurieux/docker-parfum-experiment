FROM tomcat:jdk8-openjdk
COPY ./ROOT /usr/local/tomcat/webapps/ROOT
COPY ./temp /usr/local/tomcat/temp

# To demonstrate SSRF AWS, comment the following out if not required.
RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
COPY ./setup-aws-simulator.sh /
RUN chmod +x /setup-aws-simulator.sh
ENTRYPOINT /setup-aws-simulator.sh && catalina.sh run
#ENTRYPOINT catalina.sh run
