FROM openjdk:8-jre
MAINTAINER perfree <perfree@126.com>
ENV LANG en_US.UTF-8
ARG PACKAGE_FILE
COPY ${PACKAGE_FILE} app.tar.gz
RUN tar -zxvf app.tar.gz
RUN cp -r perfree-web/* /
RUN mv perfree-web app
ENTRYPOINT ["java","-jar","/perfree-web.jar", "isDocker"]