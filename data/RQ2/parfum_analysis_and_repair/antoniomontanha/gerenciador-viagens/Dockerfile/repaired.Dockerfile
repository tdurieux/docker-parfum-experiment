FROM ubuntu:18.04

RUN apt-get update

COPY . /data/gerenciador-viagens
WORKDIR /data/gerenciador-viagens

RUN chmod +x /data/gerenciador-viagens/start-app.sh
RUN ls -la /data/gerenciador-viagens

RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install --no-install-recommends oracle-java8-installer -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends maven -y && rm -rf /var/lib/apt/lists/*;

EXPOSE 8089

RUN ls -la /data/gerenciador-viagens

CMD [ "bash", "/data/gerenciador-viagens/start-app.sh" ]
