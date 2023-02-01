FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y \
 openjdk-11-jdk \
 maven \
 make && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/fresco
ADD . /home/fresco
RUN mvn clean install -DskipTests
