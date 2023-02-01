FROM debian
RUN apt-get update && apt-get install --no-install-recommends -y git libshout-dev gcc openjdk-8-jdk maven && rm -rf /var/lib/apt/lists/*;
RUN mkdir /libshout-java
COPY . ./libshout-java
WORKDIR /libshout-java
