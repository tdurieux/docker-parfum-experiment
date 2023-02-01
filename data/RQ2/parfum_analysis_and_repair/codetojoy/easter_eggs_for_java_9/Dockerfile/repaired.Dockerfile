FROM openjdk:9-jdk

RUN apt-get update
RUN apt-get install -y
RUN apt-get install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;

