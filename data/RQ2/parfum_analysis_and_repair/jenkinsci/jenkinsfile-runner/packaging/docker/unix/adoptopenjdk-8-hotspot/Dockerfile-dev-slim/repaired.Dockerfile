FROM maven:3.6.3-adoptopenjdk-8 as jenkinsfilerunner-build
RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
# Prepare the Jenkins core
COPY vanilla-package/target/war/jenkins.war /src/jenkins.war
RUN mkdir /app && unzip /src/jenkins.war -d /app/jenkins && \
  rm -rf /app/jenkins/scripts /app/jenkins/jsbundles /app/jenkins/css /app/jenkins/images /app/jenkins/help /app/jenkins/WEB-INF/detached-plugins /app/jenkins/WEB-INF/jenkins-cli.jar /app/jenkins/WEB-INF/lib/jna-4.5.2.jar

# Delete HPI files and use the archive directories instead
COPY vanilla-package/target/plugins /src/plugins
RUN echo "Optimizing plugins..." && \
  cd /src/plugins && \
  rm -rf *.hpi && \
  for f in * ; do echo "Exploding $f..." && mv "$f" "$f.hpi" ; done;


FROM adoptopenjdk:8u262-b10-jdk-hotspot
RUN apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*

ENV JENKINS_UC https://updates.jenkins.io
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc
ENV JENKINS_PM_VERSION 2.5.0
ENV JENKINS_PM_URL https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_PM_VERSION}/jenkins-plugin-manager-${JENKINS_PM_VERSION}.jar

COPY app/target/appassembler /app
COPY --from=jenkinsfilerunner-build /app/jenkins /app/jenkins
COPY --from=jenkinsfilerunner-build /src/plugins /usr/share/jenkins/ref/plugins
COPY /packaging/docker/unix/jenkinsfile-runner-launcher /app/bin

VOLUME /build
VOLUME /usr/share/jenkins/ref/casc

ENTRYPOINT ["/app/bin/jenkinsfile-runner-launcher"]
