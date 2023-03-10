FROM gradle:6.8.3-jdk11 as build
ARG VERIFY_USE_PUBLIC_BINARIES=false
USER gradle
RUN mkdir /home/gradle/verify-service-provider \
 && chown --recursive gradle:gradle /home/gradle/verify-service-provider
WORKDIR /home/gradle/verify-service-provider
ENV GRADLE_USER_HOME ~/.gradle

COPY --chown=gradle:gradle build.gradle settings.gradle src ./
RUN gradle installDist

ENTRYPOINT ["gradle"]
CMD ["tasks"]

FROM openjdk:11.0.9.1-jre

WORKDIR /verify-service-provider

COPY verify-service-provider.yml verify-service-provider.yml
COPY --from=build /home/gradle/verify-service-provider/build/install/verify-service-provider .

ENTRYPOINT ["sh", "-c"]
CMD ["bin/verify-service-provider", "server", "verify-service-provider.yml"]