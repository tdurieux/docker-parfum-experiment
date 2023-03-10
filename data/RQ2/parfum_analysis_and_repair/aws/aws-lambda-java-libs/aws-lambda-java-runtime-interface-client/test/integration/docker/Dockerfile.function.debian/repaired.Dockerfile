ARG DISTRO_VERSION

FROM public.ecr.aws/debian/debian:${DISTRO_VERSION} as build-image

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget gpg software-properties-common && \
    wget -O- https://apt.corretto.aws/corretto.key | apt-key add - && \
    add-apt-repository 'deb https://apt.corretto.aws stable main' && \
    apt-get update && \
    apt-get install --no-install-recommends -y java-11-amazon-corretto-jdk && rm -rf /var/lib/apt/lists/*;

FROM public.ecr.aws/debian/debian:${DISTRO_VERSION}

COPY --from=build-image /usr/lib/jvm /usr/lib/jvm

ADD aws-lambda-java-runtime-interface-client/test/integration/test-handler/target/HelloWorld-1.0.jar .

ENV PATH=/usr/lib/jvm/java-11-amazon-corretto/bin/:$PATH

ENTRYPOINT ["java", "-jar", "./HelloWorld-1.0.jar"]

CMD ["helloworld.App"]
