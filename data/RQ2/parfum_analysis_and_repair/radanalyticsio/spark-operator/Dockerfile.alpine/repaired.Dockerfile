FROM jkremser/mini-jre:8.1

ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -XshowSettings:vm"

LABEL BASE_IMAGE="jkremser/mini-jre:8"

ADD spark-operator/target/spark-operator-*.jar /spark-operator.jar

CMD ["/usr/bin/java", "-jar", "/spark-operator.jar"]