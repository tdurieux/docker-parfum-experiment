FROM sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/maven:3.8.3-adoptopenjdk-11 AS build
COPY . /app
WORKDIR /app
RUN mkdir /root/.m2/ && curl -f https://sreworks.oss-cn-beijing.aliyuncs.com/resource/settings.xml -o /root/.m2/settings.xml
RUN mvn -Dmaven.test.skip=true clean package

FROM sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/openjdk11:alpine-jre AS release
USER root
WORKDIR /root
COPY --from=build /app/sreworks-job-worker/target/sreworks-job.jar /app/sreworks-job.jar
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add --no-cache build-base curl && apk add --no-cache bash python3 && apk add --no-cache python3-dev
RUN pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple && pip3 config set global.trusted-host mirrors.aliyun.com
RUN pip3 install --no-cache-dir requests python-dateutil==1.4 --pre gql[aiohttp]
ENTRYPOINT ["java", "-Xmx1g", "-Xms1g", "-XX:ActiveProcessorCount=2", "-jar", "/app/sreworks-job.jar"]



