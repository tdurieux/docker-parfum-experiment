ARG DISTRO_VERSION

FROM public.ecr.aws/docker/library/centos:centos${DISTRO_VERSION}

RUN rpm --import https://yum.corretto.aws/corretto.key && \
    curl -f -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo && \
    yum install -y java-11-amazon-corretto-devel && rm -rf /var/cache/yum

ADD aws-lambda-java-runtime-interface-client/test/integration/test-handler/target/HelloWorld-1.0.jar .

ENTRYPOINT ["java", "-jar", "./HelloWorld-1.0.jar"]

CMD ["helloworld.App"]
