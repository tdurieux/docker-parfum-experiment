FROM tomcat:jdk8-adoptopenjdk-openj9
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar -o /jolokia-jvm-1.6.2-agent.jar
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
