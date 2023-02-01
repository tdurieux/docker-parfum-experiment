# 预发环境的Dockerfile ： https://lark.alipay.com/aone/docker/rm2g1d
# 用基础镜像地址替换下方镜像地址
# FROM reg.docker.alibaba-inc.com/aone-base/pandora-boot-base:1.0
FROM reg.docker.alibaba-inc.com/aone-base/tkg-one_pandora_update:20190923175509
# 指定运行时的系统环境变量,如下请替换appName为自己应用名称
ARG APP_NAME
ENV APP_NAME=${APP_NAME}
ENV APP_TEST=${APP_NAME}

# 增加sls相关配置
RUN mkdir /etc/ilogtail/
RUN touch /etc/ilogtail/user_defined_id
RUN echo tkgone-pre > /etc/ilogtail/user_defined_id
RUN mkdir /etc/ilogtail/users/
RUN touch /etc/ilogtail/users/1270632786127642

# 当使用默认的基础镜像 reg.docker.alibaba-inc.com/aone-base/spring-boot-base:1.0 需要下面两行语句,如果是自定义的镜像请删除这行
RUN mkdir -p /home/admin/${APP_NAME} &&  ln  -s /home/admin/App/* /home/admin/${APP_NAME}/
WORKDIR /home/admin/${APP_NAME}/bin

# 设置spring profile或者自定义的jvm参数。如果需要则打开下面的注释内容
# ENV SERVICE_OPTS=-Dspring.profiles.active=staging

# 将构建出的主包复制到指定镜像目录中