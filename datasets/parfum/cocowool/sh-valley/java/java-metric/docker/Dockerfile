FROM frolvlad/alpine-glibc
ADD jre-8u231-linux-x64.tar.gz /usr/java/jdk
ENV JAVA_HOME /usr/java/jdk/jre1.8.0_231
ENV PATH ${PATH}:${JAVA_HOME}/bin
COPY metrics-core-4.0.5.jar /home/lib/metrics-core-4.0.5.jar
COPY slf4j-api-1.7.25.jar /home/lib/slf4j-api-1.7.25.jar
COPY slf4j-simple-1.7.28.jar /home/lib/slf4j-simple-1.7.28.jar
COPY learn-metrics-1.0.jar /home/learn-metrics-1.0.jar
CMD java -Xbootclasspath/a:/home/lib/metrics-core-4.0.5.jar:/home/lib/slf4j-api-1.7.25.jar:/home/lib/slf4j-simple-1.7.28.jar -jar /home/learn-metrics-1.0.jar timer
