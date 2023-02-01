FROM lzbgt/jdk8base
WORKDIR /
COPY ./app.jar /app.jar
COPY config /config

EXPOSE 80

CMD java -jar /app.jar