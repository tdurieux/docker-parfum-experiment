FROM maven:3-jdk-8-slim

WORKDIR /app

# install
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# basic functionality
ENV LANG="en_US.UTF-8" TZ="Europe/Berlin"

EXPOSE 8080

# Copy the current directory contents into the container
COPY . .

# Install discourse simplification
RUN ./install-DiscourseSimplification.sh

# Install project
RUN mvn clean install -DskipTests
RUN mvn -P server clean package -DskipTests

# Deploy
RUN mkdir -p /app/deployment
RUN tar -zxvf graphene-server/target/graphene-server-3.1.0-dist.tar.gz -C /app/deployment && rm graphene-server/target/graphene-server-3.1.0-dist.tar.gz

WORKDIR /app/deployment

CMD ["bin/start.sh"]
