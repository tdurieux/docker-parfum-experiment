FROM maven:3.6.3-jdk-11-slim

RUN apt-get update && apt-get install --no-install-recommends -y git libxrender1 libxext6 libxtst6 libfreetype6 libfontconfig1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src

COPY . .

RUN mvn -Dmaven.test.skip=true install

#CMD mvn install
CMD java -jar ac-ui/target/*SNAPSHOT*.jar