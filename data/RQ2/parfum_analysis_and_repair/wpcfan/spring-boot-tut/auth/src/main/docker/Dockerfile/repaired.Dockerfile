#-----------------------------------------------------------------------------------------------------
# Config Server
#-----------------------------------------------------------------------------------------------------
FROM openjdk:8u121-jdk-alpine

LABEL author="Peng Wang <wpcfan@gmail.com>"

# Keep consistent with build.gradle
ENV APP_JAR_NAME auth
ENV APP_JAR_VERSION 0.0.1

# Install curl
RUN apk --update --no-cache add curl bash && \
	rm -rf /var/cache/apk/*

RUN mkdir /app

ADD ${APP_JAR_NAME}-${APP_JAR_VERSION}.jar /app/
ADD run.sh /app/
RUN chmod +x /app/run.sh

WORKDIR /app

EXPOSE 8899

ENTRYPOINT ["/bin/bash","-c"]
CMD ["/app/run.sh"]
