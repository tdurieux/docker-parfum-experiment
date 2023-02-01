FROM frolvlad/alpine-glibc
ADD jre-8u231-linux-x64.tar.gz /usr/java/jdk
ENV JAVA_HOME /usr/java/jdk/jre1.8.0_231
ENV PATH ${PATH}:${JAVA_HOME}/bin
COPY commons-cli-1.4.jar /home/lib/commons-cli-1.4.jar
COPY kafka-clients-0.10.2.0.jar /home/lib/kafka-clients-0.10.2.0.jar
COPY kafka-clients-2.1.0.jar /home/lib/kafka-clients-2.1.0.jar
COPY lz4-1.3.0.jar /home/lib/lz4-1.3.0.jar
COPY lz4-java-1.5.0.jar /home/lib/lz4-java-1.5.0.jar
COPY metrics-core-2.2.0.jar /home/lib/metrics-core-2.2.0.jar
COPY slf4j-api-1.7.21.jar /home/lib/slf4j-api-1.7.21.jar
COPY slf4j-api-1.7.25.jar /home/lib/slf4j-api-1.7.25.jar
COPY slf4j-simple-1.7.28.jar /home/lib/slf4j-simple-1.7.28.jar
COPY snappy-java-1.1.2.6.jar /home/lib/snappy-java-1.1.2.6.jar
COPY snappy-java-1.1.7.2.jar /home/lib/snappy-java-1.1.7.2.jar
COPY zstd-jni-1.3.5-4.jar /home/lib/zstd-jni-1.3.5-4.jar
COPY learn-kafka-1.0.jar  /home/learn-kafka-1.0.jar
CMD java -Xbootclasspath/a:/home/lib/kafka-clients-0.10.2.0.jar:/home/lib/slf4j-simple-1.7.28.jar:/home/lib/slf4j-api-1.7.21.jar:/home/lib/commons-cli-1.4.jar -jar /home/learn-kafka-1.0.jar -t producer