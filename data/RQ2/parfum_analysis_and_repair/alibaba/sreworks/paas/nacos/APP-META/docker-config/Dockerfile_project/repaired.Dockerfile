# 基础镜像的Dockerfile ： https://lark.alipay.com/aone/docker/rm2g1d
# 基于基础镜像
FROM reg.docker.alibaba-inc.com/aone-base/tesla-nacos_base:20200224162704

# 指定应用名字，配置在$APP_NAME.release文件里
# 从 build.tools.docker.args=--build-arg APP_NAME=${APP_NAME} 传入
ARG APP_NAME
ENV APP_NAME=${APP_NAME}


#拷贝配置文件到conf目录下
COPY conf/project/cluster.conf /home/admin/${APP_NAME}/conf/

############# project #################
# 设置spring profile或者自定义的jvm参数。如果需要则打开下面的注释内容
# ENV SERVICE_OPTS=-Dspring.profiles.active=project

# 将构建出的主包复制到指定镜像目录中