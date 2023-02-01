FROM softinstigate/graalvm:latest

LABEL maintainer="SoftInstigate <info@softinstigate.com>"

WORKDIR /opt/restheart
COPY bin/entrypoint-graalvm.sh entrypoint.sh
COPY target/restheart.jar .
COPY target/plugins/* plugins/

SHELL ["/bin/bash", "-i", "-c"]

ENV RHO='/mongo-uri->"mongodb://host.docker.internal";/http-host->"0.0.0.0"'
ENTRYPOINT [ "/opt/restheart/entrypoint.sh" ]
EXPOSE 8009 8080 4443