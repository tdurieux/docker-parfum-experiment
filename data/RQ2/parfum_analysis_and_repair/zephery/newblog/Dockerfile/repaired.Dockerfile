FROM openjdk:11

MAINTAINER 1570631036@qq.com

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install --no-install-recommends python3 -y && apt-get install --no-install-recommends python3-pip -y && apt-get clean \
    && pip3 install --no-cache-dir redis && rm -rf /var/lib/apt/lists/*;

ADD src/main/resources/pythonfiles/getbaidu.py /data/logs/newblog/getbaidu.py

COPY target/*.war /app/newblog.war

WORKDIR /data/logs/newblog

CMD ["java","-Dspring.profiles.active=prod,common","-jar","/app/newblog.war"]
