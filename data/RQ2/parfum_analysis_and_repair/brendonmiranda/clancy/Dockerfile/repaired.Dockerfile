FROM openjdk:13-alpine

ARG JAR_BASE_NAME=${JAR_BASE_NAME}
ARG BUILD_VERSION=${BUILD_VERSION}
ARG JAR_FILE=$JAR_BASE_NAME-$BUILD_VERSION.jar

ARG START_SCRIPT=start.sh

COPY ${JAR_FILE} app.jar
COPY ${START_SCRIPT} start.sh

ENTRYPOINT ["./start.sh"]

CMD ["${BOT_OWNER}", "${BOT_TOKEN}", "${BOT_PREFIX}", "${BOT_INACTIVE_THRESHOLD}", "${BOT_TASK_INACTIVE_FIXED_DELAY}", "${BOT_RABBIT_HOSTNAME}", "${BOT_RABBIT_USERNAME}", "${BOT_RABBIT_PASSWORD}", "${BOT_RABBIT_VIRTUALHOST}", "${BOT_RABBIT_CONNECTION_TIMEOUT}", "${BOT_RABBIT_REQUEST_HEARTBEAT}", "${BOT_RABBIT_QUEUE_TTL}"]