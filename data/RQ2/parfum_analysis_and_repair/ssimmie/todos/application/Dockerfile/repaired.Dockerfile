FROM openjdk:11
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} todos.jar
RUN apt-get update && apt-get install --no-install-recommends -y wait-for-it && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["java","-jar","/todos.jar"]
EXPOSE 8181
