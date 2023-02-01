FROM openjdk:7-jdk

RUN apt update && apt install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;
