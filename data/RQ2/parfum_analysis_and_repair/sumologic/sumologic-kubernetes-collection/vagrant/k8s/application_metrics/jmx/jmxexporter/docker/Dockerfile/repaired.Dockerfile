FROM tomcat:jdk8-adoptopenjdk-openj9
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar -o /jmx_prometheus_javaagent-0.13.0.jar
ENV CATALINA_OPTS "-javaagent:/jmx_prometheus_javaagent-0.13.0.jar=8888:/config.yaml"
