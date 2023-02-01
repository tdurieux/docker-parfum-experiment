FROM registry.cn-qingdao.aliyuncs.com/duodianyouhui/com-hlj-springboot-docker:1
#FROM java:8
MAINTAINER HealerJean
COPY dockerDirectory/Shanghai  /etc/localtime

ADD target/com-hlj-springboot-docker-0.0.1-SNAPSHOT.jar app.jar
CMD ["java","-jar","-Duser.timezone=GMT+8","/app.jar"]