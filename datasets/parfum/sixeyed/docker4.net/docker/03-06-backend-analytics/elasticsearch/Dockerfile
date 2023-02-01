FROM mcr.microsoft.com/windows/nanoserver:1809 AS download
ARG ELASTIC_VERSION="6.8.12"

RUN curl -o elasticsearch.zip https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-%ELASTIC_VERSION%.zip
RUN tar -xzf elasticsearch.zip

# elasticsearch
FROM openjdk:11-jdk-nanoserver-1809
ARG ELASTIC_VERSION="6.8.12"

EXPOSE 9200 9300
ENV ES_HOME="/usr/share/elasticsearch" \
    ES_JAVA_OPTS="-Xms1024m -Xmx1024m"

WORKDIR /usr/share/elasticsearch
COPY --from=download /elasticsearch-${ELASTIC_VERSION}/ .
COPY docker/03-06-backend-analytics/elasticsearch/elasticsearch.yml \
     docker/03-06-backend-analytics/elasticsearch/log4j2.properties \
     config/

USER ContainerAdministrator
CMD ["bin\\elasticsearch.bat"]