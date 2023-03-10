ARG DISTRO_VERSION

FROM public.ecr.aws/docker/library/alpine:${DISTRO_VERSION}

RUN apk update && \
    apk add --no-cache openjdk8

ADD aws-lambda-java-runtime-interface-client/test/integration/test-handler/target/HelloWorld-1.0.jar .

ENTRYPOINT ["java", "-jar", "./HelloWorld-1.0.jar"]

CMD ["helloworld.App"]
