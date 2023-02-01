FROM java:8

RUN apt-get update && apt-get install --no-install-recommends -y gradle && rm -rf /var/lib/apt/lists/*; #RUN apt-get install bash


EXPOSE 8081
WORKDIR /project
VOLUME /c/Users/steve/projects/microservice-documentation-tool/example/customer-service:/project
ENTRYPOINT ["./gradlew", "bootrun"]