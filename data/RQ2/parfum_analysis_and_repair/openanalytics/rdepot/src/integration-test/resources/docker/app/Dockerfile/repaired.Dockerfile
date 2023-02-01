FROM adoptopenjdk:11-jre-openj9

LABEL MAINTAINER Jonas Van Malder "jonas.vanmalder@openanalytics.eu"

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4
RUN apt-get update -y && apt-get install --no-install-recommends -y r-base texlive texinfo texlive-fonts-extra mc net-tools && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT exec java $JAVA_OPTS -jar /opt/rdepot/rdepot.war --spring.config.additional-location=file:/opt/rdepot/application.yml