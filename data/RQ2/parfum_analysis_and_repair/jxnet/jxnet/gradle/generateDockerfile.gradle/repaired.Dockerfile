task generateDockerfile() {
    String dockerFIle = """
FROM java:8

# Install libpcap.
RUN apt-get update && \\
 apt-get install --no-install-recommends -y libpcap0.8 libpcap-dev wget git gcc && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/jxnet

RUN git clone -b v1 --single-branch https://github.com/jxnet/Jxnet.git Jxnet
RUN cd Jxnet && ./gradlew build -x test
ENTRYPOINT ["java", "-jar", "jxnet-spring-boot-starter-example/build/libs/jxnet-spring-boot-starter-example-${VERSION}.jar"]
"""
    new File("$projectDir/Dockerfile").text = dockerFIle
}
