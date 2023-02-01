FROM openjdk:8-jdk

VOLUME /tmp

RUN apt-get update && \
    apt-get -y --no-install-recommends install rabbitmq-server && \
    apt-get -y --no-install-recommends install mongodb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD build/libs/ticktok-*.jar /opt/app/app.jar

ADD entrypoint.sh /opt/app
RUN chmod +x /opt/app/entrypoint.sh

ADD sandbox/prepare_sandbox.sh /opt/app
RUN chmod +x /opt/app/prepare_sandbox.sh

WORKDIR /opt/app

EXPOSE 5672

CMD ["./prepare_sandbox.sh", "&&", "./entrypoint.sh"]