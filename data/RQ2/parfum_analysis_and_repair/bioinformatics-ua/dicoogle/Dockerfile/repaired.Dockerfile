FROM openjdk:8

WORKDIR /root

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common build-essential git maven && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/bioinformatics-ua/dicoogle
RUN ( cd dicoogle && mvn install && ln -s /root/dicoogle/dicoogle/target/dicoogle.jar /root/ )

CMD ["java","-jar","dicoogle.jar","-s"]
