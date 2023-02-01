FROM openjdk:8-jdk-stretch

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
COPY ./ /var/www
WORKDIR /var/www
EXPOSE 8080
