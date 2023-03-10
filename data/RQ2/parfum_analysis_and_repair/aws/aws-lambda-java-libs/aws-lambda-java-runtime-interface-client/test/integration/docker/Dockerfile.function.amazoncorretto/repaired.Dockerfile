ARG RUNTIME_VERSION

FROM public.ecr.aws/amazoncorretto/amazoncorretto:${RUNTIME_VERSION}

ADD aws-lambda-java-runtime-interface-client/test/integration/test-handler/target/HelloWorld-1.0.jar .

ENTRYPOINT ["java", "-jar", "./HelloWorld-1.0.jar"]

CMD ["helloworld.App"]