FROM maven:3.5.2-jdk-8
EXPOSE 8080

RUN mkdir -p /authlete/app

ADD . /authlete/app

WORKDIR /authlete/app

RUN mvn -s /usr/share/maven/ref/settings-docker.xml clean install && \
    # Import the root certificate of Open Banking Brasil Sandbox
    certs/import-certificate.sh certs/Open_Banking_Brasil_Sandbox_Root_G1.pem

CMD ["mvn", "-s", "/usr/share/maven/ref/settings-docker.xml", "clean", "jetty:run"]
