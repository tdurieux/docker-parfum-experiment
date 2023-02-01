FROM adoptopenjdk/openjdk8-openj9 as build

RUN apt-get update && \
    apt-get install --no-install-recommends -y maven unzip && rm -rf /var/lib/apt/lists/*;

COPY . /project

# Install user-app dependencies
WORKDIR /project/user-app
COPY ./user-app/src ./src
COPY ./user-app/pom.xml ./
RUN mvn -B clean package

FROM adoptopenjdk:8-jre-openj9

WORKDIR /work/
COPY --from=build /project/user-app/target/*.jar /work/

RUN chmod 775 /work
EXPOSE 8080
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar /work/*.jar"]