# 基础镜像说明
# openjdk:11.0.6-jre → 涉及图形界面UI相关API操作时使用（如：验证码生成），镜像大小 ≈ 200M
# openjdk:11.0.6-jre-slim → 极简化的jar包运行环境，镜像大小 ≈ 100M
# registry-vpc.cn → 为阿里云专有网络，公网拉取镜像时请改为：registry.cn
FROM registry-vpc.cn-beijing.aliyuncs.com/yl-yue/openjdk:11.0.6-jre-slim

MAINTAINER ylyue yl-yue@qq.com

# 添加时区环境变量，亚洲，上海
ENV TimeZone=Asia/Shanghai

# 使用软连接，并且将时区配置覆盖/etc/timezone