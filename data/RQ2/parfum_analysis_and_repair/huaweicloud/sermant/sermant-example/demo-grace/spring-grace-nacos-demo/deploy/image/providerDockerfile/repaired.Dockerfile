FROM ascdc/jdk8:latest

WORKDIR /home

COPY jars/nacos-rest-provider-2.2.0.RELEASE.jar /home
COPY startProvider.sh /home

RUN chmod -R 777 /home
EXPOSE 8004 5009
ENTRYPOINT ["sh", "/home/startProvider.sh"]