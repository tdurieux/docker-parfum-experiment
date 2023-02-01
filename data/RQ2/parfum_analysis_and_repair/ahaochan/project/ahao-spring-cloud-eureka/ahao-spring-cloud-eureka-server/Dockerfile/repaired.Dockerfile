# Docker file 需要移动到父模块下, 并且此 Dockefile 生成镜像耗时长, 多在下载依赖
# TODO 运行错误, 可能是 jre 版本问题
# mv ./ahao-spring-cloud-eureka/Dockerfile ./Dockerfile
# docker build -t tomcat-eureka .
# docker run -d -p 8761:8761 -e PROFILE=server tomcat-eureka