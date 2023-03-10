FROM openjdk:8 as java
FROM gcr.io/kythe-public/kythe-javac-extractor-artifacts as javac-extractor-artifacts
FROM gradle:latest as gradle

FROM debian:jessie
VOLUME /repo
ENV KYTHE_ROOT_DIRECTORY=/repo
VOLUME /out
ENV KYTHE_OUTPUT_DIRECTORY=/out
WORKDIR /repo
COPY --from=java /docker-java-home /docker-java-home
COPY --from=java /etc/java-8-openjdk /etc/java-8-openjdk
ENV JAVA_HOME=/docker-java-home
ENV PATH=$JAVA_HOME/bin:$PATH
COPY --from=javac-extractor-artifacts /opt/kythe/extractors/runextractor /opt/kythe/extractors/runextractor
COPY --from=javac-extractor-artifacts /opt/kythe/extractors/javac-wrapper.sh /opt/kythe/extractors/javac-wrapper.sh
COPY --from=javac-extractor-artifacts /opt/kythe/extractors/javac_extractor.jar /opt/kythe/extractors/javac_extractor.jar
ENV KYTHE_CORPUS=testcorpus
ENV REAL_JAVAC=$JAVA_HOME/bin/javac
ENV JAVAC_EXTRACTOR_JAR=/opt/kythe/extractors/javac_extractor.jar
ENV KYTHE_OUTPUT_FILE=$KYTHE_OUTPUT_DIRECTORY/extractor-output.kzip
COPY --from=gradle /usr/share/gradle /usr/share/gradle
COPY --from=gradle /etc/ssl /etc/ssl
ENV GRADLE_HOME=/usr/share/gradle
ENV PATH=$GRADLE_HOME/bin:$PATH
ENTRYPOINT ["/opt/kythe/extractors/runextractor", "gradle", "-build_file", "build.gradle", "-javac_wrapper", "/opt/kythe/extractors/javac-wrapper.sh"]