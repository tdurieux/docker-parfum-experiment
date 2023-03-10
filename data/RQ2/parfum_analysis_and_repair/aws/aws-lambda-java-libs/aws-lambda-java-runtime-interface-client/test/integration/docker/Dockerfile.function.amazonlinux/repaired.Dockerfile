ARG DISTRO_VERSION

FROM public.ecr.aws/amazonlinux/amazonlinux:${DISTRO_VERSION}

RUN yum install -y java-1.8.0-openjdk && rm -rf /var/cache/yum

ADD aws-lambda-java-runtime-interface-client/test/integration/test-handler/target/HelloWorld-1.0.jar .

ENTRYPOINT ["java", "-jar", "./HelloWorld-1.0.jar"]

CMD ["helloworld.App"]
