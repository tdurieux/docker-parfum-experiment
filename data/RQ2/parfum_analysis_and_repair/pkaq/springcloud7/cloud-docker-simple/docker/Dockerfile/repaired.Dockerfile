# 基于哪哥镜像
FROM daocloud.io/java:8
# 拷贝文件到容器
ADD cloud-docker-simple.jar /app.jar
# 打开服务端口
EXPOSE 8080
# 配置容器启动后执行的命令