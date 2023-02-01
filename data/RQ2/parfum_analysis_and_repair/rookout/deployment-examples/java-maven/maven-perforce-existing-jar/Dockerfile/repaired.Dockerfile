FROM maven:3.6-jdk-8-slim
ADD pom.xml pom.xml
#https://stackoverflow.com/questions/42208442/maven-docker-cache-dependencies
RUN mvn -B -f ./pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
RUN apt update  -y && apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
ADD . .
RUN mvn package