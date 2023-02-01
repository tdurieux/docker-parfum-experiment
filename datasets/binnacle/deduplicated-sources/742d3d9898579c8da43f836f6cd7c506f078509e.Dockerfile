FROM openjdk:8-jre-alpine

LABEL maintainer="Vulas vulas-dev@listserv.sap.com"

ARG VULAS_RELEASE

COPY rest-backend-$VULAS_RELEASE.jar /vulas/rest-backend.jar
COPY run.sh /vulas/run.sh
RUN touch /$VULAS_RELEASE

EXPOSE 8091

RUN chmod +x /vulas/run.sh

CMD ["/vulas/run.sh"]
