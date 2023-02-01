FROM openjdk:11

RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

COPY . bxbot-staging

WORKDIR ./bxbot-staging
RUN mvn clean package
RUN cp ./bxbot-app/target/bxbot-app-*-dist.tar.gz /

WORKDIR /
RUN tar -xzf bxbot-app-*-dist.tar.gz && rm bxbot-app-*-dist.tar.gz
RUN rm bxbot-app-*-dist.tar.gz
RUN rm -rf ./bxbot-staging

EXPOSE 8080
