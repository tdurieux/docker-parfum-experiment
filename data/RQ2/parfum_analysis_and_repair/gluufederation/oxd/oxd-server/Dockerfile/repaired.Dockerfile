FROM openjdk:8-jre
LABEL maintainer="Michal Kepkowski"

COPY target/oxd-server.jar /oxd-server.jar
COPY config/config_template.yml /config_template.yml
ADD config/config_gen.sh /config_gen.sh

RUN apt-get -qqy update && apt-get -qqy --no-install-recommends install gettext-base && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/config_gen.sh"]
EXPOSE 8443 8444

