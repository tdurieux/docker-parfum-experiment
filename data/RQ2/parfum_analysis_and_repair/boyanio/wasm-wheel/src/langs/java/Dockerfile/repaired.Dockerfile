FROM openjdk:8-jdk AS wheel-part-java

WORKDIR /work
COPY . .

RUN apt-get update && \
    apt-get install --no-install-recommends -y maven && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mvn install && \
    mkdir ../output && \
    cp target/wasm/output.wasm ../output/wheel-part-java.wasm && \
    rm -rf target/* && \
    rm -rf /root/.m2/*