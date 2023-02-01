FROM openjdk:7
RUN apt-get update && apt-get install --no-install-recommends -y wget && wget https://www.exploit-db.com/apps/b7be2fc190b26377ced5ae6055ed43e2-apache-solr-3.5.0.tgz && tar -zxf b7be2fc190b26377ced5ae6055ed43e2-apache-solr-3.5.0.tgz && rm b7be2fc190b26377ced5ae6055ed43e2-apache-solr-3.5.0.tgz && rm -rf /var/lib/apt/lists/*;
WORKDIR /apache-solr-3.5.0/example
CMD java -jar start.jar