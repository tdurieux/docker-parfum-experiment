#获取base image
FROM adoptopenjdk/openjdk8:latest 
MAINTAINER moyu 11184629@qq.com

#类似于linux copy指令
COPY moyu-system-1.0.0.jar /opt/app/layuicloud/       
#对外端口
EXPOSE 9000
#执行命令 java -jar /opt/app/layuicloud/moyu-system-1.0.0.jar