FROM openjdk:8-slim

COPY JPPF-@version@-driver /jppf
WORKDIR /jppf
EXPOSE 11111/tcp
EXPOSE 11443/tcp

RUN /bin/sh -c "chmod +x ./start-driver.sh" \
    && mkdir /jppf-config

COPY tls/*.* /jppf-config/

CMD ["sh",  "start-driver.sh"]