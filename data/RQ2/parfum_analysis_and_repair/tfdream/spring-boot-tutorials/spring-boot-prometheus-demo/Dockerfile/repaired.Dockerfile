# 添加 Java 8 镜像来源
FROM java:8

# 添加参数
ARG JAR_FILE

# 添加 Spring Boot 包
ADD target/${JAR_FILE} app.jar

# 执行启动命令