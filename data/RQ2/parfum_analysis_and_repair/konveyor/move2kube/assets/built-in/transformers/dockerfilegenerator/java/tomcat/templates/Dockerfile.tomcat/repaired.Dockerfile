FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
WORKDIR /usr/local
RUN microdnf update && microdnf install -y {{ .JavaPackageName }} wget tar gzip shadow-utils && microdnf clean all

# environment variables
ENV CATALINA_PID='/usr/local/tomcat10/temp/tomcat.pid' CATALINA_HOME='/usr/local/tomcat10' CATALINA_BASE='/usr/local/tomcat10'
{{- range $k, $v := .EnvVariables }}
ENV {{ $k }} {{ $v }}
{{- end }}

# install tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz && \
    tar -zxf apache-tomcat-10.0.16.tar.gz && \
    rm -f apache-tomcat-10.0.16.tar.gz && \
    mv apache-tomcat-10.0.16 tomcat10 && \
    rm -r "$CATALINA_BASE"/webapps/ROOT && \
    mkdir "$CATALINA_BASE"/webapps-javaee/ && \
    adduser -r tomcat && chown -R tomcat:root tomcat10 && \
    usermod -aG root tomcat && \
    chmod -R g+rwX tomcat10/
USER tomcat:root

COPY --chown=tomcat:root {{ if .BuildContainerName }}--from={{ .BuildContainerName }} {{ end }}{{ .DeploymentFilePath }} "$CATALINA_BASE"/webapps-javaee/
EXPOSE {{ .Port }}
CMD [ "/usr/local/tomcat10/bin/catalina.sh", "run" ]