FROM openjdk:8-jdk-alpine as build
WORKDIR /workspace/app
COPY . .
RUN ./mvnw -N dependency:resolve
RUN ./mvnw install -DskipTests
VOLUME /root/.m2

FROM dsyer/graalvm-native-image:1.0.0-rc7 as native
WORKDIR /workspace/app
ARG SAMPLE=application
COPY --from=build /root/.m2 /root/.m2
COPY --from=build /workspace/app/samples/${SAMPLE}/target/*.jar target/app.jar
COPY --from=build /workspace/app/samples/${SAMPLE}/*.json target/
RUN mkdir target/app && cd target/app && jar -xf ../app.jar
RUN /usr/lib/graalvm/bin/native-image --no-server --static -J-javaagent:/root/.m2/repository/org/aspectj/aspectjweaver/1.9.1/aspectjweaver-1.9.1.jar -H:Name=target/app -H:ReflectionConfigurationFiles=`echo target/*.json | tr ' ' ,` -H:ReflectionConfigurationResources=META-INF/library.json -H:IncludeResources='META-INF/.*.json|META-INF/spring.factories|org/springframework/boot/logging/.*' --delay-class-initialization-to-runtime=org.springframework.core.io.VfsUtils  --report-unsupported-elements-at-runtime -cp `/usr/lib/graalvm/bin/java -jar ~/.m2/repository/org/springframework/boot/experimental/spring-boot-thin-launcher/*/*-exec.jar --thin.classpath --thin.profile=graal --thin.archive=target/app` app.main.SampleApplication

FROM alpine
WORKDIR /workspace/app
VOLUME /tmp
COPY --from=native /workspace/app/target/app .
EXPOSE 8080
ENTRYPOINT ["./app"]